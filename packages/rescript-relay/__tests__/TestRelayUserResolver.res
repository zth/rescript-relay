/**
 * @RelayResolver User.fullName:RelayResolverValue
 * @rootFragment TestRelayUserResolver
 *
 * A users full name.
 */
type t = string

module Fragment = %relay(`
  fragment TestRelayUserResolver on User {
    firstName
    lastName
  }
`)

let default = Fragment.makeRelayResolver(user => {
  Some(`${user.firstName} ${user.lastName}`)
})
