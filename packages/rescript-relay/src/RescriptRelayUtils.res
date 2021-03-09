open RescriptRelay

let resolveNestedRecord = (
  ~rootRecord: option<RescriptRelay.RecordProxy.t>,
  ~path: list<string>,
) => {
  let currentRecord = ref(rootRecord)
  let pathLength = List.length(path)

  switch pathLength {
  | 0 => ()
  | _ =>
    for i in 0 to pathLength - 1 {
      let currentPath = path->Belt.List.get(i)
      switch (currentRecord.contents, currentPath) {
      | (Some(record), Some(currentPath)) =>
        currentRecord := record->RescriptRelay.RecordProxy.getLinkedRecord(~name=currentPath, ())
      | _ => currentRecord := None
      }
    }
  }

  currentRecord.contents
}

let resolveNestedRecordFromRoot = (~store, ~path: list<string>) =>
  switch path {
  | list{} => None
  | list{rootRecordPath} =>
    switch store->RescriptRelay.RecordSourceSelectorProxy.getRootField(~fieldName=rootRecordPath) {
    | Some(rootRecord) => Some(rootRecord)
    | None => None
    }
  | list{rootRecordPath, ...restPath} =>
    resolveNestedRecord(
      ~rootRecord=store->RescriptRelay.RecordSourceSelectorProxy.getRootField(
        ~fieldName=rootRecordPath,
      ),
      ~path=restPath,
    )
  }

type insertAt =
  | Start
  | End

type connectionConfig = {
  parentID: dataId,
  key: string,
  filters: option<RescriptRelay.arguments>,
}

let removeNodeFromConnections = (~store, ~node, ~connections) =>
  connections->Belt.List.forEach(connectionConfig =>
    switch store->RecordSourceSelectorProxy.get(~dataId=connectionConfig.parentID) {
    | Some(owner) =>
      switch ConnectionHandler.getConnection(
        ~record=owner,
        ~key=connectionConfig.key,
        ~filters=?connectionConfig.filters,
        (),
      ) {
      | Some(connection) =>
        ConnectionHandler.deleteNode(~connection, ~nodeId=node->RecordProxy.getDataId)
      | None => ()
      }
    | None => ()
    }
  )

let createAndAddEdgeToConnections = (~store, ~node, ~connections, ~edgeName, ~insertAt) =>
  connections->Belt.List.forEach(connectionConfig =>
    switch store->RecordSourceSelectorProxy.get(~dataId=connectionConfig.parentID) {
    | Some(connectionOwner) =>
      switch ConnectionHandler.getConnection(
        ~record=connectionOwner,
        ~key=connectionConfig.key,
        ~filters=?connectionConfig.filters,
        (),
      ) {
      | Some(connection) =>
        let edge = ConnectionHandler.createEdge(~store, ~connection, ~node, ~edgeType=edgeName)
        switch insertAt {
        | Start => ConnectionHandler.insertEdgeAfter(~connection, ~newEdge=edge, ())
        | End => ConnectionHandler.insertEdgeBefore(~connection, ~newEdge=edge, ())
        }
      | None => ()
      }
    | None => ()
    }
  )
