module Query = %relay(`
    query TestCodesplitQuery {
      member(id: "1") {
        ...HasNameComponent_hasName @autoCodesplit @alias
        ... on User {
          ...UserAvatar_user @autoCodesplit @alias
          description {
            ...RichContent_content @autoCodesplit @alias
          }
        }
        ... on Group {
          ...GroupAvatar_group @autoCodesplit @alias
        }
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let (shouldRender, setShouldRender) = React.useState(() => false)

    switch (shouldRender, query.member) {
    | (false, _) =>
      <button
        onClick={_ => {
          setShouldRender(_ => true)
        }}>
        {React.string("Render")}
      </button>
    | (true, None) => React.string("not found")
    | (true, Some(member)) =>
      open Query.CodesplitComponents

      <div>
        {switch member {
        | {hasNameComponent_hasName: Some(hasNameComponent_hasName)} =>
          <HasNameComponent hasName=hasNameComponent_hasName.fragmentRefs />
        | _ => React.null
        }}
        {switch member {
        | {groupAvatar_group: Some(groupAvatar_group)} =>
          <GroupAvatar group=groupAvatar_group.fragmentRefs />
        | {userAvatar_user: Some(userAvatar_user), description} =>
          <>
            <UserAvatar user=userAvatar_user.fragmentRefs />
            {switch description {
            | Some({richContent_content}) =>
              <RichContent content=richContent_content.fragmentRefs />
            | None => React.null
            }}
          </>
        | _ => React.null
        }}
      </div>
    }
  }
}

@live
let test_codesplit = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
