module QueryLoggedInUserProp = %relay(`
  query TestCatchLoggedInUserPropQuery {
    loggedInUser {
      createdAt @catch
      isOnline @catch
      ...TestCatchUser_user
    }
  }
`)

module LoggedInUserFragment = %relay(`
  fragment TestCatchUser_user on User @catch {
    createdAt
  }
`)

module TestLoggedInUserProp = {
  @react.component
  let make = () => {
    let query = QueryLoggedInUserProp.use(~variables=())

    <>
      {switch query.loggedInUser.createdAt {
      | Ok({value: createdAt}) =>
        <div>
          {React.string(
            "Got createdAt: " ++ createdAt->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10),
          )}
        </div>
      | Error(_) => <div> {React.string("Error!")} </div>
      }}
      {switch query.loggedInUser.isOnline {
      | Ok({value: isOnline}) =>
        <div>
          {React.string(
            "Got isOnline: " ++
            switch isOnline {
            | Some(true) => "true"
            | Some(false) => "false"
            | None => "null"
            },
          )}
        </div>
      | Error(_) => <div> {React.string("Error isOnline!")} </div>
      }}
    </>
  }
}

module TestLoggedInUserPropFragmentData = {
  @react.component
  let make = () => {
    let query = QueryLoggedInUserProp.use(~variables=())
    let fragmentData = LoggedInUserFragment.use(query.loggedInUser.fragmentRefs)

    switch fragmentData {
    | Ok({value: {createdAt}}) =>
      <div>
        {React.string(
          "Got createdAt: " ++ createdAt->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10),
        )}
      </div>
    | Error(_) => <div> {React.string("Error!")} </div>
    }
  }
}

module QueryMember = %relay(`
  query TestCatchMemberPropQuery {
    member(id: "123") @catch  {
      ... on User {
        id
        createdAt
      }
    }
  }
`)

module TestMember = {
  @react.component
  let make = () => {
    let query = QueryMember.use(~variables=())

    switch query.member {
    | Ok({value: Some(User({id, createdAt}))}) =>
      <div>
        {React.string(
          "Got user id: " ++
          id ++
          ", and createdAt: " ++
          createdAt->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10),
        )}
      </div>
    | Error(_) => <div> {React.string("Error!")} </div>
    | _ => React.null
    }
  }
}

module QueryMemberNested = %relay(`
  query TestCatchMemberPropNestedQuery {
    member(id: "123")  {
      ... on User {
        id
        memberOfSingular @catch {
          ... on User {
            id
            createdAt
          }
        }
      }
    }
  }
`)

module TestMemberNested = {
  @react.component
  let make = () => {
    let query = QueryMemberNested.use(~variables=())

    switch query.member {
    | Some(User({id, memberOfSingular: Ok({value: Some(User({createdAt}))})})) =>
      <div>
        {React.string(
          "Got user id: " ++
          id ++
          ", and createdAt: " ++
          createdAt->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10),
        )}
      </div>
    | Some(User({memberOfSingular: Error(_)})) => <div> {React.string("Error nested!")} </div>
    | _ => React.null
    }
  }
}

module QueryMembers = %relay(`
  query TestCatchMembersPropQuery {
    members(groupId: "123") {
      edges {
        node @catch {
          ... on User {
            id
            createdAt
          }
        }
      }
    }
  }
`)

module TestMembers = {
  @react.component
  let make = () => {
    let query = QueryMembers.use(~variables=())

    let members =
      query.members
      ->Belt.Option.flatMap(v => v.edges)
      ->Belt.Option.getWithDefault([])
      ->Belt.Array.keepMap(x => x->Belt.Option.map(r => r.node))

    members
    ->Js.Array2.map(r =>
      switch r {
      | Ok({value: Some(User({id, createdAt}))}) =>
        `User: ${id} - ${createdAt->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10)}`
      | _ => "Error!"
      }
    )
    ->Js.Array2.joinWith(", ")
    ->React.string
  }
}

@live
let test_catch = testName => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    {switch testName {
    | "TestLoggedInUserProp" => <TestLoggedInUserProp />
    | "TestLoggedInUserPropFragmentData" => <TestLoggedInUserPropFragmentData />
    | "TestMember" => <TestMember />
    | "TestMemberNested" => <TestMemberNested />
    | "TestMembers" => <TestMembers />
    | _ => React.null
    }}
  </TestProviders.Wrapper>
}
