@react.component
let make = (~name) => {
  React.string(name)
}

module ExportedForDynamicImport__ = {
  let make = make
}
