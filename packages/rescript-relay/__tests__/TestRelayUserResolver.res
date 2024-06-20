type t = string

module Fragment = %relay(`
  fragment TestRelayUserResolver on User {
    firstName
    lastName
  }
`)

/**
 * @RelayResolver User.fullName:RelayResolverValue
 * @rootFragment TestRelayUserResolver
 *
 * A users full name.
 */
let fullName = Fragment.makeRelayResolver(user => {
  Some(`${user.firstName} ${user.lastName}`)
})
