module Fragment = %relay(`
  fragment TestRelayUserResolver2 on User {
    firstName
    lastName
  }
`)

/**
 * @RelayResolver User.fullName2(maxLength: Int!): String
 * @rootFragment TestRelayUserResolver2
 *
 * A users full name 2.
 */
let fullName2 = (user, args) => {
  let user = Fragment.readResolverFragment(user)
  `${user.firstName} ${user.lastName}`->Js.String2.slice(~from=0, ~to_=args.maxLength)
}
