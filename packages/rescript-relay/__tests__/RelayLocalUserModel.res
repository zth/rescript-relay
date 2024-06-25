type t = {
  id: string,
  name: string,
}

module UserService = {
  let getById = id => Some({id, name: "Test User"})
}
/**
 * @RelayResolver LocalUser
 */
let localUser /* : LocalUser_relayResolvers_graphql.localUser_entityResolver */ = id => {
  UserService.getById(id->RescriptRelay.dataIdToString)
}
