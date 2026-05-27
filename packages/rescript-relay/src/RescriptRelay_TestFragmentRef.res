let make = (fragmentName: string, data: 'fragment): 'fragmentRefs => {
  ignore(fragmentName)
  ignore(data)
  %raw(`({__rescriptRelaySyntheticFragmentRef: true, fragmentName, data})`)
}

let makePlural = (fragmentName: string, data: array<'fragment>): array<'fragmentRefs> => {
  ignore(fragmentName)
  let fragmentRefs = data->Array.map(fragment => make(fragmentName, fragment))
  ignore(
    %raw(`
      Object.defineProperties(fragmentRefs, {
        __rescriptRelaySyntheticFragmentRef: {value: true},
        fragmentName: {value: fragmentName}
      })
    `),
  )
  fragmentRefs
}

let getDataForNode = (node: 'node, fragmentRef: 'fragmentRef): option<'fragment> => {
  ignore(node)
  ignore(fragmentRef)
  %raw(`
    (() => {
      const fragmentName = node.name;

      if (Array.isArray(fragmentRef)) {
        if (
          fragmentRef.__rescriptRelaySyntheticFragmentRef !== true ||
          fragmentRef.fragmentName !== fragmentName
        ) {
          return undefined;
        }

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

      if (
        fragmentRef != null &&
        typeof fragmentRef === "object" &&
        fragmentRef.__rescriptRelaySyntheticFragmentRef === true &&
        fragmentRef.fragmentName === fragmentName
      ) {
        return fragmentRef.data;
      }

      return undefined;
    })()
  `)
}
