/** Collects all non-null nodes from a connection. */
let collectConnectionNodes:
  {
    ..
    "edges":
      Js.Nullable.t(array(Js.Nullable.t({.. "node": Js.Nullable.t('a)}))),
  } =>
  array('a);

/** Same as collectConnectionNodes, but takes a nullable connection. */
let collectConnectionNodesFromNullable:
  Js.Nullable.t({
    ..
    "edges":
      Js.Nullable.t(array(Js.Nullable.t({.. "node": Js.Nullable.t('a)}))),
  }) =>
  array('a);

/** Collects all non-null nodes from an array of nullables. */
let collectNodes: array(Js.Nullable.t('a)) => array('a);

/** Same as collectNodes, but takes a nullable array. */
let collectNodesFromNullable:
  Js.Nullable.t(array(Js.Nullable.t('a))) => array('a);
