module Query = %relay(`
  query TestRequiredFieldLoggerQuery {
    loggedInUser {
      firstName @required(action: LOG)
    }
  }
`)

module Logger = {
  let loggedArg = ref((None: option<RescriptRelay.RequiredFieldLogger.arg>))

  let mock: RescriptRelay.RequiredFieldLogger.t = arg => loggedArg := Some(arg)

  let getLoggedArg = () => loggedArg.contents

  let expectedArg: RescriptRelay.RequiredFieldLogger.arg = MissingFieldLog({
    owner: "TestRequiredFieldLoggerQuery",
    fieldPath: "loggedInUser.firstName",
  })
}

@live
let test_requiredFieldLogger = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
    ~requiredFieldLogger=Logger.mock,
  )

  Js.Promise.make((~resolve, ~reject as _) => {
    Query.fetch(~environment, ~variables=(), ~onResult=res => resolve(res))
  })
}

let getLoggedArg = Logger.getLoggedArg

let expectedArg = Logger.expectedArg
