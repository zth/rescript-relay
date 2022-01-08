module Query = %relay(`
    query TestUnionFragmentQuery {
      member(id: "123") {
        __typename
        ...TestUnionFragment_member
        ...TestUnionFragment_plural_member
      }
    }
`)

module Fragment = %relay(`
    fragment TestUnionFragment_member on Member {
      __typename
      ... on User {
        firstName
        onlineStatus
        ...TestUnionFragmentUser_user
      }
      ... on Group {
        name
      }
    }
`)

module UserFragment = %relay(`
  fragment TestUnionFragmentUser_user on User {
    firstName
    onlineStatus
  }
`)

module PluralFragment = %relay(`
    fragment TestUnionFragment_plural_member on Member @relay(plural: true) {
      __typename
      ... on User {
        firstName
        onlineStatus
        ...TestUnionFragmentUser_user
      }
      ... on Group {
        name
      }
    }
`)

module UserFragmentRenderer = {
  @react.component
  let make = (~user, ~prefix="") => {
    let user = UserFragment.use(user)

    <div> {React.string(prefix ++ "Yup, " ++ user.firstName ++ " is here.")} </div>
  }
}

module FragmentRenderer = {
  @react.component
  let make = (~fragment) => {
    let regular = Fragment.use(fragment)
    let plural = PluralFragment.use([fragment])

    <>
      {switch regular {
      | #User({onlineStatus: Some(#Online), firstName, fragmentRefs}) => <>
          <div> {React.string(firstName ++ " is online")} </div>
          <UserFragmentRenderer user=fragmentRefs />
        </>
      | _ => React.null
      }}
      {switch plural {
      | [#User({onlineStatus: Some(#Online), firstName, fragmentRefs})] => <>
          <div> {React.string("plural: " ++ (firstName ++ " is online"))} </div>
          <UserFragmentRenderer prefix="plural: " user=fragmentRefs />
        </>

      | _ => React.null
      }}
    </>
  }
}

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())

    switch query.member {
    | Some(member) => <FragmentRenderer fragment=member.fragmentRefs />
    | None => React.null
    }
  }
}

@live
let test_unionFragment = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
