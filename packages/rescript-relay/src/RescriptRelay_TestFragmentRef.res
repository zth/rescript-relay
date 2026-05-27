let make = (fragmentName: string, data: 'fragment): 'fragmentRefs => {
  ignore(fragmentName)
  ignore(data)
  %raw(`({__rescriptRelaySyntheticFragmentRef: true, fragmentName, data})`)
}

let makePlural = (fragmentName: string, data: array<'fragment>): array<'fragmentRefs> =>
  data->Array.map(fragment => make(fragmentName, fragment))

let getDataForNode = (node: 'node, fragmentRef: 'fragmentRef): option<'fragment> => {
  ignore(node)
  ignore(fragmentRef)
  %raw(`
    (() => {
      const fragmentName = node.name;

      if (
        fragmentRef != null &&
        typeof fragmentRef === "object" &&
        fragmentRef.__rescriptRelaySyntheticFragmentRef === true &&
        fragmentRef.fragmentName === fragmentName
      ) {
        return fragmentRef.data;
      }

      if (Array.isArray(fragmentRef)) {
        const data = [];
        for (let i = 0; i < fragmentRef.length; i++) {
          const ref = fragmentRef[i];
          if (
            ref == null ||
            typeof ref !== "object" ||
            ref.__rescriptRelaySyntheticFragmentRef !== true ||
            ref.fragmentName !== fragmentName
          ) {
            return undefined;
          }
          data.push(ref.data);
        }
        return data;
      }

      return undefined;
    })()
  `)
}
