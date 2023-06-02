open RescriptRelay

@module("relay-runtime/lib/store/ResolverFragments")
external readFragment_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readFragment"

type resolver<'fragment, 't> = 'fragment => option<'t>

// This is abstract just to hide the implementation details that don't need to be known anyway.
type relayResolver
external mkRelayResolver: 'a => relayResolver = "%identity"

let makeRelayResolver = (
  ~node,
  ~convertFragment: 'fragment => 'fragment,
  resolver: resolver<'fragment, 't>,
) => {
  let relayResolver = fRef => {
    resolver(readFragment_(node, fRef)->convertFragment)
  }
  relayResolver->mkRelayResolver
}
