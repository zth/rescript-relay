module Fragment = %relay(`
  fragment UserName_user on User {
    firstName
    lastName
  }
`)

@react.component
let make = (~user: RescriptRelay.fragmentRefs<[#UserName_user]>) => {
  let user = Fragment.use(user)
  <div> {React.string("User name: " ++ user.firstName ++ " " ++ user.lastName)} </div>
}
