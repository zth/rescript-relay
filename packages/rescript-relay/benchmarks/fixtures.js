// Plain fixtures keep this benchmark independent of compilation and React.
const rows = Array.from({ length: 100 }, (_, i) => ({
  id: String(i),
  name: "User " + i,
  status: i % 2 ? "ONLINE" : "OFFLINE",
  avatar: null,
  profile: { bio: null, score: i },
}));
const converters = {
  enum: (v) => v.toLowerCase(),
  scalar: (v) => new Date(v),
  union: (v) => v,
};
const cases = [
  {
    name: "small fragment",
    root: rows[0],
    maps: { __root: { "": { f: "" }, status: { e: "enum" } } },
  },
  {
    name: "unchanged object",
    root: { id: "1", name: "User", profile: { score: 42 } },
    maps: {},
  },
  {
    name: "nullable query",
    root: { viewer: rows[0], missing: null },
    maps: {},
  },
  {
    name: "connection / 100 rows",
    root: { users: { edges: rows.map((node) => ({ cursor: node.id, node })) } },
    maps: {
      __root: {
        users_edges_node: { f: "" },
        users_edges_node_status: { e: "enum" },
      },
    },
  },
  {
    name: "plural fragment / 100 rows",
    root: rows,
    maps: { __root: { "": { f: "" }, status: { e: "enum" } } },
  },
  {
    name: "union list / 100 rows",
    root: { members: rows.map((v) => ({ ...v, __typename: "User" })) },
    maps: {
      __root: {
        members: { u: "union" },
        members_User: { f: "" },
        members_User_status: { e: "enum" },
      },
    },
  },
  {
    name: "custom scalar list",
    root: { dates: Array(100).fill("2025-01-01T00:00:00Z"), after: null },
    maps: { __root: { dates: { ca: "scalar" } } },
  },
  {
    name: "opaque JSON list",
    root: { items: rows },
    maps: { __root: { items: { b: "a" } } },
  },
  {
    name: "recursive inputs",
    root: { input: { status: "ONLINE", children: rows } },
    maps: {
      __root: { input: { r: "Input" } },
      Input: { status: { e: "enum" }, children: { r: "Input" } },
    },
    nullable: null,
  },
];
module.exports = { cases, converters };

// Expected data is independent of the instruction interpreter. Fragment refs are
// checked separately in unit/mounted tests (older releases rewrote nested refs).
const convertedRow = (row, nullable, enumValue) => ({
  ...row,
  avatar: nullable,
  status: enumValue ? row.status.toLowerCase() : row.status,
  profile: { ...row.profile, bio: nullable },
});
const expected = [
  convertedRow(rows[0], undefined, true),
  cases[1].root,
  { viewer: convertedRow(rows[0], undefined, false), missing: undefined },
  {
    users: {
      edges: rows.map((row) => ({
        cursor: row.id,
        node: convertedRow(row, undefined, true),
      })),
    },
  },
  rows.map((row) => convertedRow(row, undefined, true)),
  {
    members: rows.map((row) => ({
      ...convertedRow(row, undefined, true),
      __typename: "User",
    })),
  },
  {
    dates: Array.from({ length: 100 }, () => new Date("2025-01-01T00:00:00Z")),
    after: undefined,
  },
  { items: rows },
  {
    input: {
      status: "online",
      children: rows.map((row) => convertedRow(row, null, true)),
    },
  },
];
cases.forEach((fixture, i) => {
  fixture.expected = expected[i];
});
