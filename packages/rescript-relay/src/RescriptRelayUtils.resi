@ocaml.doc("Tries to return a record from a nested path of linked records.")
let resolveNestedRecord: (
  ~rootRecord: option<RescriptRelay.RecordProxy.t>,
  ~path: list<string>,
) => option<RescriptRelay.RecordProxy.t>

@ocaml.doc(
  "Tries to return a record from a nested path of linked records, starting from the root. "
)
let resolveNestedRecordFromRoot: (
  ~store: RescriptRelay.RecordSourceSelectorProxy.t,
  ~path: list<string>,
) => option<RescriptRelay.RecordProxy.t>

@ocaml.doc("Helpers for handling connections. ")
type insertAt =
  | Start
  | End

type connectionConfig = {
  parentID: RescriptRelay.dataId,
  key: string,
  filters: option<RescriptRelay.arguments>,
}

let removeNodeFromConnections: (
  ~store: RescriptRelay.RecordSourceSelectorProxy.t,
  ~node: RescriptRelay.RecordProxy.t,
  ~connections: list<connectionConfig>,
) => unit

let createAndAddEdgeToConnections: (
  ~store: RescriptRelay.RecordSourceSelectorProxy.t,
  ~node: RescriptRelay.RecordProxy.t,
  ~connections: list<connectionConfig>,
  ~edgeName: string,
  ~insertAt: insertAt,
) => unit
