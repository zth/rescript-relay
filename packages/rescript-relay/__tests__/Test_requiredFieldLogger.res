module Query = %relay(`
  query TestRequiredFieldLoggerQuery {
    loggedInUser {
      firstName @required(action: LOG)
    }
  }
`)

module Logger = {
  let loggedArg = ref((None: option<RescriptRelay.RelayFieldLogger.arg>))

  let mock: RescriptRelay.RelayFieldLogger.t = arg => loggedArg := Some(arg)

  let getLoggedArg = () => loggedArg.contents

  let expectedArg: RescriptRelay.RelayFieldLogger.arg = MissingRequiredFieldLog({
    owner: "TestRequiredFieldLoggerQuery",
    fieldPath: "loggedInUser.firstName",
    uiContext: None,
  })
}

@live
let test_requiredFieldLogger = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
    ~relayFieldLogger=Logger.mock,
  )

  Js.Promise.make((~resolve, ~reject as _) => {
    Query.fetch(~environment, ~variables=(), ~onResult=res => resolve(res))
  })
}

let getLoggedArg = Logger.getLoggedArg

let expectedArg = Logger.expectedArg
