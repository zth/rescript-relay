open ReasonRelay;

/**
 * resolveNestedRecord
 */

let resolveNestedRecord =
    (~rootRecord: option(ReasonRelay.RecordProxy.t), ~path: list(string)) => {
  let currentRecord = ref(rootRecord);
  let pathLength = List.length(path);

  switch (pathLength) {
  | 0 => ()
  | _ =>
    for (i in 0 to pathLength - 1) {
      let currentPath = path->Belt.List.get(i);
      switch (currentRecord^, currentPath) {
      | (Some(record), Some(currentPath)) =>
        currentRecord :=
          record->ReasonRelay.RecordProxy.getLinkedRecord(
            ~name=currentPath,
            ~arguments=None,
          )
      | _ => currentRecord := None
      };
    }
  };

  currentRecord^;
};

/**
 * resolveNestedRecordFromRoot
 */

let resolveNestedRecordFromRoot = (~store, ~path: list(string)) =>
  switch (path) {
  | [] => None
  | [rootRecordPath] =>
    switch (
      store->ReasonRelay.RecordSourceSelectorProxy.getRootField(
        ~fieldName=rootRecordPath,
      )
    ) {
    | Some(rootRecord) => Some(rootRecord)
    | None => None
    }
  | [rootRecordPath, ...restPath] =>
    resolveNestedRecord(
      ~rootRecord=
        store->ReasonRelay.RecordSourceSelectorProxy.getRootField(
          ~fieldName=rootRecordPath,
        ),
      ~path=restPath,
    )
  };

/**
 * Handling nodes in connections
 */

type insertAt =
  | Start
  | End;

type connectionConfig = {
  parentID: dataId,
  key: string,
  filters: option(Js.t({.})),
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
             ~filters=connectionConfig.filters,
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