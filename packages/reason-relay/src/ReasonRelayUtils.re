open ReasonRelay;

let collectConnectionNodes = obj =>
  switch (obj##edges |> Js.Nullable.toOption) {
  | Some(edges) =>
    edges->Belt.Array.keepMap(edge =>
      switch (edge |> Js.Nullable.toOption) {
      | Some(edge) =>
        switch (edge##node |> Js.Nullable.toOption) {
        | Some(node) => Some(node)
        | None => None
        }
      | None => None
      }
    )
  | None => [||]
  };

/**
   * resolveNestedRecords
   */
[@bs.module "relay-utils"]
external _resolveNestedRecord:
  (option(RecordProxy.t), array(string)) => Js.Nullable.t(RecordProxy.t) =
  "resolveNestedRecord";

let resolveNestedRecord = (~rootRecord, ~path) =>
  _resolveNestedRecord(rootRecord, path->Belt.List.toArray)
  |> Js.Nullable.toOption;

/**
 * Handling nodes in connections
 */

type insertAt =
  | Start
  | End;

type connectionConfig = {
  parentID: dataId,
  key: string,
};

let removeNodeFromConnections = (~store, ~node, ~connections) =>
  connections
  |> List.iter(connectionConfig =>
       switch (
         store->RecordSourceSelectorProxy.get(
           ~dataId=connectionConfig.parentID,
         )
       ) {
       | Some(owner) =>
         switch (
           ConnectionHandler.getConnection(
             ~record=owner,
             ~key=connectionConfig.key,
             ~filters=None,
           )
         ) {
         | Some(connection) =>
           ConnectionHandler.deleteNode(
             ~connection,
             ~nodeId=node->RecordProxy.getDataId,
           )
         | None => ()
         }
       | None => ()
       }
     );

let createAndAddEdgeToConnections =
    (~store, ~node, ~connections, ~edgeName, ~insertAt) =>
  connections
  |> List.iter(connectionConfig =>
       switch (
         store->RecordSourceSelectorProxy.get(
           ~dataId=connectionConfig.parentID,
         )
       ) {
       | Some(connectionOwner) =>
         switch (
           ConnectionHandler.getConnection(
             ~record=connectionOwner,
             ~key=connectionConfig.key,
             ~filters=None,
           )
         ) {
         | Some(connection) =>
           let edge =
             ConnectionHandler.createEdge(
               ~store,
               ~connection,
               ~node,
               ~edgeType=edgeName,
             );
           switch (insertAt) {
           | Start =>
             ConnectionHandler.insertEdgeAfter(
               ~connection,
               ~newEdge=edge,
               ~cursor=None,
             )
           | End =>
             ConnectionHandler.insertEdgeBefore(
               ~connection,
               ~newEdge=edge,
               ~cursor=None,
             )
           };
         | None => ()
         }
       | None => ()
       }
     );