// Independent, intentionally allocating evaluator over a schema-shaped model.
// It does not use the runtime's path tree, compilation, or copy-on-write logic.
const object = (fields = {}, fragments = false) => ({
  kind: "object",
  fields,
  fragments,
});
const list = (item) => ({ kind: "list", item });
const scalar = (name) => ({ kind: "scalar", name });
const opaque = { kind: "opaque" };
const reference = (name) => ({ kind: "reference", name });
const union = (name, members) => ({ kind: "union", name, members });
const isMetadata = (key) =>
  key.startsWith("__") &&
  key !== "__id" &&
  key !== "__typename" &&
  !key.startsWith("__relay_internal");
const isOption = (v) =>
  v != null && typeof v === "object" && v.BS_PRIVATE_NESTED_SOME_NONE >= 0;
function unwrap(v) {
  return v && Object.hasOwn(v, "__$inputUnion")
    ? { [v.__$inputUnion]: v._0 }
    : v;
}
function evaluate(schema, value, definitions, converters, nullable) {
  if (value == null) return nullable;
  if (isOption(value)) return value;
  switch (schema.kind) {
    case "scalar":
      return converters[schema.name](value);
    case "opaque":
      return value;
    case "list":
      return value.map((v) =>
        evaluate(schema.item, v, definitions, converters, nullable),
      );
    case "reference":
      return evaluate(
        definitions[schema.name],
        unwrap(value),
        definitions,
        converters,
        nullable,
      );
    case "union": {
      const member = schema.members[value.__typename] || object();
      const raw = nullable === null ? converters[schema.name](value) : value;
      const converted = evaluate(
        member,
        raw,
        definitions,
        converters,
        nullable,
      );
      return nullable === undefined
        ? converters[schema.name](converted)
        : converted;
    }
    case "object": {
      if (Array.isArray(value))
        return value.map((v) =>
          evaluate(schema, v, definitions, converters, nullable),
        );
      const result = { ...value };
      for (const key of Object.keys(value)) {
        if (isMetadata(key)) continue;
        const field = schema.fields[key];
        result[key] = field
          ? evaluate(field, value[key], definitions, converters, nullable)
          : normalize(value[key], nullable);
      }
      if (schema.fragments) {
        result.fragmentRefs = { ...value };
        result.updatableFragmentRefs = result.fragmentRefs;
      }
      return result;
    }
    default:
      throw new Error("Invalid model kind");
  }
}
function normalize(v, nullable) {
  if (v == null) return nullable;
  if (isOption(v) || typeof v !== "object") return v;
  if (Array.isArray(v)) return v.map((item) => normalize(item, nullable));
  return Object.fromEntries(
    Object.keys(v).map((key) => [
      key,
      isMetadata(key) ? v[key] : normalize(v[key], nullable),
    ]),
  );
}
function encode(definitions) {
  const roots = {};
  for (const [name, schema] of Object.entries(definitions)) {
    const entries = [];
    function visit(node, path) {
      const entry = { path };
      let depth = 0;
      while (node.kind === "list") {
        depth++;
        node = node.item;
      }
      if (depth) entry.list = depth;
      if (node.kind === "scalar") entry.scalar = node.name;
      if (node.kind === "reference") entry.reference = node.name;
      if (node.kind === "opaque") entry.opaque = true;
      if (node.kind === "union") entry.union = node.name;
      if (node.kind === "object" && node.fragments) entry.fragments = true;
      if (Object.keys(entry).length > 1) entries.push(entry);
      if (node.kind === "object")
        for (const [key, child] of Object.entries(node.fields))
          visit(child, [...path, key]);
      if (node.kind === "union")
        for (const [key, child] of Object.entries(node.members))
          visit(child, [...path, key]);
    }
    visit(schema, []);
    roots[name] = entries;
  }
  return { version: 2, roots };
}
function freeze(v, seen = new Set()) {
  if (!v || typeof v !== "object" || seen.has(v)) return v;
  seen.add(v);
  Object.values(v).forEach((item) => freeze(item, seen));
  return Object.freeze(v);
}
module.exports = {
  object,
  list,
  scalar,
  opaque,
  reference,
  union,
  encode,
  evaluate,
  freeze,
};
