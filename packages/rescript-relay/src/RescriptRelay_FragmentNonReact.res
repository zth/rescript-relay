/* React-free Fragment runtime: read, readInlineData, waitForFragmentData */

open RescriptRelay

type fragmentNode<'node> = RescriptRelay.fragmentNode<'node>

@module("relay-runtime/lib/store/ResolverFragments")
external readFragment_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readFragment"

@module("relay-runtime/experimental")
external waitForFragmentData_: (
  Environment.t,
  fragmentNode<'node>,
  'fragmentRef,
) => promise<'fragment> = "waitForFragmentData"

let read = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) =>
  convertFragment(readFragment_(node, fRef))

let waitForFragmentData = async (
  ~environment,
  ~node,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef,
) => {
  let fragmentData = await waitForFragmentData_(environment, node, fRef)
  convertFragment(fragmentData)
}
