open RescriptRelay

type fragmentNode<'node> = RescriptRelay.fragmentNode<'node>

let read: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef: 'b,
) => 'fragment

let waitForFragmentData: (
  ~environment: Environment.t,
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef: 'b,
) => promise<'fragment>
