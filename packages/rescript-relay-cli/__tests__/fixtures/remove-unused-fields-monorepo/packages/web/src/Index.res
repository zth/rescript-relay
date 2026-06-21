module Query = %relay(`
query IndexQuery {
  currentOrg {
    ...OrganizationCard
  }
}
`)

@react.component
let make = () => {
  let {currentOrg: {fragmentRefs}} = Query.use()

  <OrganizationCard fragmentRefs />
}
