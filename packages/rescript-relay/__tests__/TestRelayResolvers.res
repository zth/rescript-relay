/**
 * @RelayResolver UserMeta.online: Boolean
 */
let online: UserMeta_relayResolvers_graphql.onlineResolver = userMeta => {
  userMeta.online->Some
}

/**
 * @RelayResolver LocalUser.meta: UserMeta
 */
let meta: LocalUser_relayResolvers_graphql.metaResolver = user => {
  Some({
    online: user.name === "Test User",
  })
}

/**
 * @RelayResolver LocalUser.name: String
 */
let name: LocalUser_relayResolvers_graphql.nameResolver = user => {
  Some(user.name)
}

/**
 * @RelayResolver Query.localUser: LocalUser
 */
let localUser: Query_relayResolvers_graphql.localUserResolver = () => {
  Some({
    id: "local-user-1"->RescriptRelay.makeDataId,
  })
}
