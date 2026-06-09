module Fragment = %relay(`
fragment OrganizationCard on Organization {
  id
  name
  currentUserIsAdmin
}
`)

@react.component
let make = (~fragmentRefs) => {
  let {name} = Fragment.use(fragmentRefs)

  React.string(name)
}
