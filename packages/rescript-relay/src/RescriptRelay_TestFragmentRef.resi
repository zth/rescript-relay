let make: (string, 'fragment) => 'fragmentRefs

let makePlural: (string, array<'fragment>) => array<'fragmentRefs>

let getDataForNode: ('node, 'fragmentRef) => option<'fragment>
