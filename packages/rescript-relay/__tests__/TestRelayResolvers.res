/**
 * @RelayResolver UserMeta.online: Boolean
 */
let online = userMeta => {
  userMeta.online
}

/**
 * @RelayResolver LocalUser.meta: UserMeta
 */
let meta = user => {
  {
    online: user.name === "Test User",
  }
}

/**
 * @RelayResolver LocalUser.name: String
 */
let name = user => {
  user.name
}

/**
 * @RelayResolver Query.localUser: LocalUser
 */
let localUser = () => {
  {
    id: "local-user-1"->RescriptRelay.makeDataId,
  }
}

/**
 * @RelayResolver LocalUser.nameRepeated(times: Int!): String
 */
let nameRepeated = (user, args) => {
  user.name->String.repeat(args.times)
}

/**
 * @RelayResolver LocalUser.hasBeenOnlineToday: Boolean
 * @live
 */
let hasBeenOnlineToday = user => {
  read: suspenseSentinel => {
    switch UserService.getUserStatus(user.id) {
    | Fetching => suspenseSentinel->RescriptRelay.SuspenseSentinel.suspend
    | Value(v) => v
    }
  },
  subscribe: cb => {
    let id = UserService.subscribe(cb)
    () => UserService.unsubscribe(id)
  },
}
