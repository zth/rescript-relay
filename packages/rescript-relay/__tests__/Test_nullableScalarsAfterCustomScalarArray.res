module Query = %relay(`
  query TestNullableScalarsAfterCustomScalarArrayQuery {
    loggedInUser {
      id
      intStrings
      avatarUrl
      isOnline
      private
      onlineStatus
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = {
      Query.use(~variables=())
    }
    let user = query.loggedInUser

    let avatarUrlLabel = switch user.avatarUrl {
    | None => "avatarUrl=None"
    | Some(_) => "avatarUrl=Some(_)"
    }
    let isOnlineLabel = switch user.isOnline {
    | None => "isOnline=None"
    | Some(_) => "isOnline=Some(_)"
    }
    // For `private` we don't just report which option branch we hit — we use
    // `Type.classify` on the inner value to spell out what ReScript sees at
    // runtime. When the bug fires, the option's payload is the raw JS `null`
    // and this label renders `private=Some(null)`. That's the smoking gun:
    // the generated type says `option<bool>` but the value isn't really a
    // `bool` and isn't really `None`.
    let privateLabel = switch user.private_ {
    | None => "private=None"
    | Some(v) =>
      // The generated type says `option<bool>`, so `v: bool`. Reach past
      // the type with `Obj.magic` and check what the runtime value
      // actually is — when the bug fires it's the raw JS `null`, not a
      // boolean.
      let kind = switch (Obj.magic(v) :> Null.t<bool>)->Null.toOption {
      | None => "null"
      | Some(_) => "bool"
      }
      `private=Some(${kind})`
    }
    let onlineStatusLabel = switch user.onlineStatus {
    | None => "onlineStatus=None"
    | Some(_) => "onlineStatus=Some(_)"
    }

    <>
      <div> {avatarUrlLabel->React.string} </div>
      <div> {isOnlineLabel->React.string} </div>
      <div> {privateLabel->React.string} </div>
      <div> {onlineStatusLabel->React.string} </div>
    </>
  }
}

@live
let test_nullableScalarsAfterCustomScalarArray = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
