/**
 * @RelayResolver UserMeta.online: Boolean
 */
let online = userMeta => {
  userMeta.online->Some
}

/**
 * @RelayResolver LocalUser.meta: UserMeta
 */
let meta = user => {
  Some({
    online: user.name === "Test User",
  })
}

/**
 * @RelayResolver LocalUser.name: String
 */
let name = user => {
  Some(user.name)
}

/**
 * @RelayResolver Query.localUser: LocalUser
 */
let localUser = () => {
  Some({
    id: "local-user-1"->RescriptRelay.makeDataId,
  })
}

/**
 * @RelayResolver LocalUser.nameRepeated(times: Int!): String
 */
let nameRepeated = (user, args) => {
  user.name->Js.String2.repeat(args.times)->Some
}

/**
 * @RelayResolver LocalUser.hasBeenOnlineToday: Boolean
 * @live
 */
let hasBeenOnlineToday = user => {
  read: suspenseSentinel => {
    switch UserService.getUserStatus(user.id) {
    | Fetching => suspenseSentinel->RescriptRelay.SuspenseSentinel.suspend
    | Value(v) => Some(v)
    }
  },
  subscribe: cb => {
    let id = UserService.subscribe(cb)
    () => UserService.unsubscribe(id)
  },
}
