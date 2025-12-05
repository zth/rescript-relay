/* React-free Fragment runtime: read, readInlineData, waitForFragmentData */

open RescriptRelay

type fragmentNode<'node>

@module("relay-runtime/lib/store/ResolverFragments")
external readFragment_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readFragment"

@module("relay-runtime")
external readInlineData: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readInlineData"

@module("relay-runtime/experimental")
external waitForFragmentData_: (Environment.t, fragmentNode<'node>, 'fragmentRef) => promise<'fragment> =
  "waitForFragmentData"

let read = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) =>
  fRef->readFragment_(node)->convertFragment

let readInlineData_ = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) =>
  fRef->readInlineData(node)->convertFragment

let waitForFragmentData = (~environment, ~node, ~convertFragment: 'fragment => 'fragment, ~fRef) =>
  waitForFragmentData_(environment, node, fRef)->Promise.then(res => res->convertFragment->Promise.resolve)

