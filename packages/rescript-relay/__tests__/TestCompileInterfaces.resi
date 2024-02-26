module SubFragment: {
  module Types = TestCompileInterfacesFragment_user_graphql.Types
  module Operation = TestCompileInterfacesFragment_user_graphql
  let convertFragment: TestCompileInterfacesFragment_user_graphql.Types.fragment => TestCompileInterfacesFragment_user_graphql.Types.fragment
  let use: RescriptRelay.fragmentRefs<
    [> #TestCompileInterfacesFragment_user],
  > => TestCompileInterfacesFragment_user_graphql.Types.fragment
  let useOpt: option<RescriptRelay.fragmentRefs<[> #TestCompileInterfacesFragment_user]>> => option<
    TestCompileInterfacesFragment_user_graphql.Types.fragment,
  >
}
