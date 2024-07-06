module Fragment = %relay(`
  fragment HasNameComponent_hasName on HasName {
    name
  }
`)

@react.component
let make = (~hasName: RescriptRelay.fragmentRefs<[#HasNameComponent_hasName]>) => {
  let hasName = Fragment.use(hasName)

  <div> {React.string("Has name: " ++ hasName.name)} </div>
}
