module Fragment = %relay(`
  fragment RichContent_content on RichContent {
    content
  }
`)

@react.component
let make = (~content: RescriptRelay.fragmentRefs<[#RichContent_content]>) => {
  let content = Fragment.use(content)

  <div> {React.string("Rich content: " ++ content.content)} </div>
}
