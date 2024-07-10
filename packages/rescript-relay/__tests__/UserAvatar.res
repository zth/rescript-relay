module Fragment = %relay(`
  fragment UserAvatar_user on User {
    avatarUrl
    ...UserName_user @autoCodesplit @alias
  }
`)

@react.component
let make = (~user: RescriptRelay.fragmentRefs<[#UserAvatar_user]>) => {
  let user = Fragment.use(user)

  open Fragment.Operation.CodesplitComponents

  <>
    <div>
      {React.string("User avatarUrl: " ++ user.avatarUrl->Belt.Option.getWithDefault("-"))}
    </div>
    <UserName user=user.userName_user.fragmentRefs />
  </>
}
