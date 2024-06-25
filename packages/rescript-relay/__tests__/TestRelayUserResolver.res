type t = string

/**
 * @RelayResolver User.fullName:RelayResolverValue
 * @rootFragment TestRelayUserResolver
 *
 * A users full name.
 */
module Fragment = %relay(`
  fragment TestRelayUserResolver on User {
    firstName
    lastName
  }
`)

let fullName = Fragment.makeRelayResolver(user => {
  Some(`${user.firstName} ${user.lastName}`)
})
