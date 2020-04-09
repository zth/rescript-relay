/* @generated */

module Types = {
  type fragment_todosConnection_edges_node = {
    id: string,
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__SingleTodo_todoItem": SingleTodo_todoItem_graphql.t,
      },
  };
  type fragment_todosConnection_edges = {
    node: option(fragment_todosConnection_edges_node),
  };
  type fragment_todosConnection = {
    edges: option(array(option(fragment_todosConnection_edges))),
  };

  type fragment = {todosConnection: fragment_todosConnection};
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"todosConnection_edges":{"n":"","na":""},"todosConnection_edges_node":{"n":"","f":""}}} |}
  ];
  let fragmentConverterMap = ();
  let convertFragment = v =>
    v
    ->ReasonRelay._convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__TodoList_query": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {
  open Types;
  let getConnectionNodes_todosConnection:
    fragment_todosConnection => array(fragment_todosConnection_edges_node) =
    connection =>
      switch (connection.edges) {
      | None => [||]
      | Some(edges) =>
        edges
        ->Belt.Array.keepMap(edge =>
            switch (edge) {
            | None => None
            | Some(edge) =>
              switch (edge.node) {
              | None => None
              | Some(node) => Some(node)
              }
            }
          )
      };
};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TodoList_query",
  "type": "Query",
  "metadata": {
    "connection": [
      {
        "count": "first",
        "cursor": "after",
        "direction": "forward",
        "path": [
          "todosConnection"
        ]
      }
    ]
  },
  "argumentDefinitions": [
    {
      "kind": "LocalArgument",
      "name": "first",
      "type": "Int!",
      "defaultValue": 10
    },
    {
      "kind": "LocalArgument",
      "name": "after",
      "type": "String!",
      "defaultValue": ""
    }
  ],
  "selections": [
    {
      "kind": "LinkedField",
      "alias": "todosConnection",
      "name": "__TodoList_query_todosConnection_connection",
      "storageKey": null,
      "args": null,
      "concreteType": "TodoItemConnection",
      "plural": false,
      "selections": [
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "edges",
          "storageKey": null,
          "args": null,
          "concreteType": "TodoItemEdge",
          "plural": true,
          "selections": [
            {
              "kind": "LinkedField",
              "alias": null,
              "name": "node",
              "storageKey": null,
              "args": null,
              "concreteType": "TodoItem",
              "plural": false,
              "selections": [
                {
                  "kind": "ScalarField",
                  "alias": null,
                  "name": "id",
                  "args": null,
                  "storageKey": null
                },
                {
                  "kind": "ScalarField",
                  "alias": null,
                  "name": "__typename",
                  "args": null,
                  "storageKey": null
                },
                {
                  "kind": "FragmentSpread",
                  "name": "SingleTodo_todoItem",
                  "args": null
                }
              ]
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "cursor",
              "args": null,
              "storageKey": null
            }
          ]
        },
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "pageInfo",
          "storageKey": null,
          "args": null,
          "concreteType": "PageInfo",
          "plural": false,
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "endCursor",
              "args": null,
              "storageKey": null
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "hasNextPage",
              "args": null,
              "storageKey": null
            }
          ]
        }
      ]
    }
  ]
} |}
];
