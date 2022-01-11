module Query = %relay(`
    query TestLocalPayloadQuery @raw_response_type {
      loggedInUser {
        id
        ...TestLocalPayload_user
      }
    }
`)

module ViaNodeInterface = %relay(`
    query TestLocalPayloadViaNodeInterfaceQuery($id: ID!) @raw_response_type {
      node(id: $id) {
        ... on User {
          firstName
          avatarUrl
        }
      }
    }
`)

/*
 * Don't mind this fragment, it's mostly here to check that
 * it's actually getting inlined into the types for the query
 * payload we're committing locally below.
 */
module Fragment = %relay(`
  fragment TestLocalPayload_user on User {
    firstName
    avatarUrl
  }
`)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelay.useEnvironmentFromContext()
    let data = Query.use(~variables=(), ())
    let user = Fragment.use(data.loggedInUser.fragmentRefs)

    <div>
      <div> {React.string("Firstname: " ++ user.firstName)} </div>
      <div>
        {React.string(
          "Avatar: " ++
          switch user.avatarUrl {
          | Some(avatarUrl) => avatarUrl
          | None => "-"
          },
        )}
      </div>
      <button
        onClick={_ =>
          Query.commitLocalPayload(
            ~environment,
            ~variables=(),
            ~payload={
              loggedInUser: {
                id: data.loggedInUser.id,
                firstName: "AnotherFirst",
                avatarUrl: None,
              },
            },
          )}>
        {React.string("Update locally")}
      </button>
      <button
        onClick={_ =>
          ViaNodeInterface.commitLocalPayload(
            ~environment,
            ~variables={id: data.loggedInUser.id},
            ~payload={
              node: Some({
                id: data.loggedInUser.id,
                firstName: "AnotherFirst",
                avatarUrl: None,
                __typename: #User,
              }),
            },
          )}>
        {React.string("Update locally via Node interface")}
      </button>
    </div>
  }
}

@live
let test_query = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
