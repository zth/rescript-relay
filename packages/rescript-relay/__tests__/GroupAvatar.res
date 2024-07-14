module Fragment = %relay(`
  fragment GroupAvatar_group on Group {
    name
  }
`)

@react.component
let make = (~group: RescriptRelay.fragmentRefs<[#GroupAvatar_group]>) => {
  let group = Fragment.use(group)
  React.string("Group name: " ++ group.name)
}
