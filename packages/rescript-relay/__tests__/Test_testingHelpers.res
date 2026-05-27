module SubFragment = %relay(`
  fragment TestTestingHelpers_sub_user on User @rescriptRelayIgnoreUnused {
    lastName
  }
`)

module Fragment = %relay(`
  fragment TestTestingHelpers_user on User {
    __id
    firstName
    onlineStatus
    ...TestTestingHelpers_sub_user
  }
`)

module PluralFragment = %relay(`
  fragment TestTestingHelpers_plural_user on User @relay(plural: true) {
    id
    firstName
    onlineStatus
  }
`)

module Query = %relay(`
  query TestTestingHelpersQuery @relay_test_operation @raw_response_type {
    loggedInUser {
      id
      firstName
      onlineStatus
      ...TestTestingHelpers_user
    }
  }
`)

module Synthetic = {
  @react.component
  let make = (~user) => {
    let data = Fragment.use(user)
    let subData = SubFragment.use(data.fragmentRefs)
    <div> {React.string(data.firstName ++ " " ++ subData.lastName)} </div>
  }
}

module SyntheticOpt = {
  @react.component
  let make = (~user) => {
    let data = Fragment.useOpt(Some(user))
    <div>
      {switch data {
      | Some(data) => React.string(data.firstName ++ " via opt")
      | None => React.string("No data")
      }}
    </div>
  }
}

module SyntheticPlural = {
  @react.component
  let make = (~users) => {
    let allUsers = PluralFragment.use(users)

    <div>
      {allUsers
      ->Array.map(user =>
        <div key=user.id>
          {React.string(
            user.firstName ++
            (" is " ++
            switch user.onlineStatus {
            | Some(Online) => "online"
            | Some(Offline) => "offline"
            | Some(Idle) | Some(FutureAddedValue(_)) | None => "-"
            }),
          )}
        </div>
      )
      ->React.array}
    </div>
  }
}

module QueryHelpers = {
  @react.component
  let make = () => {
    let data = Query.use(~variables=())
    <div> {React.string(data.loggedInUser.firstName ++ " from query helper")} </div>
  }
}

module Interleaved = {
  @react.component
  let make = () => {
    let data = Query.use(~variables=())

    <div>
      <Synthetic
        user={Fragment.Test.fromData({
          __id: RescriptRelay.makeDataId("interleaved-synthetic-user"),
          firstName: "Interleaved Synthetic",
          onlineStatus: Some(Online),
          fragmentRefs: SubFragment.Test.fromData({lastName: "User"}),
        })}
      />
      <Synthetic user=data.loggedInUser.fragmentRefs />
    </div>
  }
}

@live
let synthetic = () =>
  <Synthetic
    user={Fragment.Test.fromData({
      __id: RescriptRelay.makeDataId("synthetic-user-1"),
      firstName: "Synthetic",
      onlineStatus: Some(Online),
      fragmentRefs: SubFragment.Test.fromData({lastName: "User"}),
    })}
  />

@live
let syntheticOpt = () =>
  <SyntheticOpt
    user={Fragment.Test.fromData({
      __id: RescriptRelay.makeDataId("synthetic-user-2"),
      firstName: "Synthetic",
      onlineStatus: Some(Online),
      fragmentRefs: SubFragment.Test.fromData({lastName: "User"}),
    })}
  />

@live
let syntheticPlural = () =>
  <SyntheticPlural
    users={PluralFragment.Test.fromData([
      {id: "synthetic-user-3", firstName: "Plural Synthetic", onlineStatus: Some(Online)},
    ])}
  />

@live
let environment = () => RescriptRelay_Test.createMockEnvironment()

@live
let queryHelpers = environment =>
  <TestProviders.Wrapper environment>
    <QueryHelpers />
  </TestProviders.Wrapper>

@live
let interleaved = environment =>
  <TestProviders.Wrapper environment>
    <Interleaved />
  </TestProviders.Wrapper>

@live
let resolveQueryHelpers = environment =>
  Query.Test.resolveMostRecentOperation(
    ~environment,
    ~payload={
      loggedInUser: {
        __id: Some(RescriptRelay.makeDataId("query-helper-user-1")),
        id: "query-helper-user-1",
        firstName: "Typed",
        onlineStatus: Some(Online),
        lastName: "Real",
      },
    },
  )
