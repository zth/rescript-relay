open RescriptRelay

type resolver<'fragment, 't> = 'fragment => option<'t>
type relayResolver

let makeRelayResolver: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  resolver<'fragment, 't>,
) => relayResolver
