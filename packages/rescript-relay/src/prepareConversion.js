const hasOwn = (object, key) =>
  Object.prototype.hasOwnProperty.call(object, key);
const isOption = (value) => value.BS_PRIVATE_NESTED_SOME_NONE >= 0;
const isMetadata = (key) =>
  key.startsWith("__") &&
  key !== "__typename" &&
  key !== "__id" &&
  !key.startsWith("__relay_internal");

// Preparation is deliberately separate from response traversal. It validates and
// snapshots compiler metadata once; the returned functions only visit values.
function readPlan(plan) {
  if (
    !plan ||
    plan.version !== 2 ||
    !plan.roots ||
    typeof plan.roots !== "object"
  ) {
    throw new Error("Invalid conversion plan: expected version 2 and roots");
  }
  const roots = Object.create(null);
  function node() {
    return { children: Object.create(null) };
  }
  const keys = new Set([
    "path",
    "list",
    "scalar",
    "union",
    "reference",
    "opaque",
    "fragments",
  ]);
  for (const name of Object.keys(plan.roots)) {
    const entries = plan.roots[name];
    if (!Array.isArray(entries))
      throw new Error("Invalid conversion root: " + name);
    const root = (roots[name] = node());
    for (const entry of entries) {
      if (
        !entry ||
        !Array.isArray(entry.path) ||
        !entry.path.every((key) => typeof key === "string")
      ) {
        throw new Error("Invalid conversion path in " + name);
      }
      let target = root;
      for (const key of entry.path)
        target = target.children[key] || (target.children[key] = node());
      for (const key of Object.keys(entry)) {
        if (!keys.has(key))
          throw new Error("Unknown conversion instruction: " + key);
        if (key === "path") continue;
        if (hasOwn(target, key) && target[key] !== entry[key])
          throw new Error("Conflicting conversion instruction: " + key);
        target[key] = entry[key];
      }
    }
  }
  return roots;
}

function prepareConversion(plan, callbacks, nullable, rootName = "__root") {
  if (nullable !== undefined && nullable !== null)
    throw new Error("Invalid conversion nullable sentinel");
  const roots = readPlan(plan);
  if (!hasOwn(roots, rootName))
    throw new Error("Missing conversion root: " + rootName);
  const converters = Object.create(null);

  const nullableOnly = (value) => (value == null ? nullable : value);
  function optional(convert) {
    if (convert === nullableOnly) return nullableOnly;
    return (value) =>
      value == null ? nullable : isOption(value) ? value : convert(value);
  }
  // Opaque list elements only normalize nullability; no callback dispatch or
  // traversal is needed, even when an element is itself an object or array.
  function nullableArray(values) {
    let result;
    for (let i = 0; i < values.length; i++) {
      if (!(i in values)) continue;
      const value = values[i];
      const next = value == null ? nullable : value;
      if (next !== value) {
        if (result === undefined) result = values.slice();
        result[i] = next;
      }
    }
    return result === undefined ? values : result;
  }
  function arrayOf(convert) {
    return (values) => {
      let result;
      for (let i = 0; i < values.length; i++) {
        if (!(i in values)) continue;
        const value = values[i];
        const next = convert(value);
        if (next !== value) {
          if (result === undefined) result = values.slice();
          result[i] = next;
        }
      }
      return result === undefined ? values : result;
    };
  }
  const anyArray = arrayOf((value) => any(value));
  function any(value) {
    if (value == null) return nullable;
    if (typeof value !== "object" || isOption(value)) return value;
    return Array.isArray(value) ? anyArray(value) : plainObject(value);
  }
  function record(fields, fragments) {
    return (value) => {
      let result;
      if (fragments) {
        const refs = { ...value };
        result = { ...value, fragmentRefs: refs, updatableFragmentRefs: refs };
      }
      for (const key in value) {
        if (!hasOwn(value, key) || isMetadata(key)) continue;
        const original = value[key];
        const convert = fields[key];
        const next = convert === undefined ? any(original) : convert(original);
        if (next !== original) {
          if (result === undefined) result = { ...value };
          result[key] = next;
        }
      }
      return result === undefined ? value : result;
    };
  }
  // Generic objects have no field instructions. Avoid a dictionary lookup for
  // every selected field while retaining property order and lazy copying.
  function plainObject(value) {
    let result;
    for (const key in value) {
      if (!hasOwn(value, key) || isMetadata(key)) continue;
      const original = value[key];
      const next = any(original);
      if (next !== original) {
        if (result === undefined) result = { ...value };
        result[key] = next;
      }
    }
    return result === undefined ? value : result;
  }
  function callback(name) {
    if (
      !callbacks ||
      !hasOwn(callbacks, name) ||
      typeof callbacks[name] !== "function"
    ) {
      throw new Error("Missing conversion callback: " + name);
    }
    return callbacks[name];
  }
  function compile(node) {
    const operations = ["scalar", "union", "reference", "opaque"].filter(
      (key) => hasOwn(node, key),
    );
    if (operations.length > 1)
      throw new Error(
        "Conflicting conversion operations: " + operations.join(", "),
      );
    for (const key of ["scalar", "union", "reference"]) {
      if (hasOwn(node, key) && typeof node[key] !== "string")
        throw new Error("Invalid conversion " + key);
    }
    for (const key of ["opaque", "fragments"]) {
      if (hasOwn(node, key) && node[key] !== true)
        throw new Error("Invalid conversion " + key);
    }
    const depth = node.list === undefined ? 0 : node.list;
    if (!Number.isSafeInteger(depth) || depth < 0)
      throw new Error("Invalid conversion list depth");
    const names = Object.keys(node.children);
    let convert;
    if (
      node.scalar !== undefined ||
      node.opaque ||
      node.reference !== undefined
    ) {
      if (names.length || node.fragments)
        throw new Error(
          "Leaf conversion cannot have child fields or fragments",
        );
      if (node.scalar !== undefined) convert = callback(node.scalar);
      else if (node.opaque) convert = nullableOnly;
      else {
        const target = node.reference;
        if (!hasOwn(roots, target))
          throw new Error("Missing conversion reference: " + target);
        convert = (value) =>
          converters[target](
            hasOwn(value, "__$inputUnion")
              ? { [value.__$inputUnion]: value._0 }
              : value,
          );
      }
    } else {
      const children = Object.create(null);
      for (const name of names) children[name] = compile(node.children[name]);
      if (node.union !== undefined) {
        if (node.fragments)
          throw new Error("Union fragments belong on member plans");
        const union = callback(node.union);
        convert =
          nullable === null
            ? (value) => (children[value.__typename] || any)(union(value))
            : (value) => union((children[value.__typename] || any)(value));
      } else {
        convert =
          names.length === 0 && !node.fragments
            ? any
            : record(children, node.fragments === true);
      }
    }
    convert = optional(convert);
    for (let i = 0; i < depth; i++) {
      convert = optional(convert === nullableOnly ? nullableArray : arrayOf(convert));
    }
    return convert;
  }
  for (const name of Object.keys(roots))
    converters[name] = compile(roots[name]);
  const convert = converters[rootName];
  // Plural fragments share their record/union plan with singular fragments.
  const plural = arrayOf(convert);
  const root = roots[rootName];
  const allowPlural =
    root.list === undefined &&
    root.scalar === undefined &&
    root.reference === undefined &&
    !root.opaque;
  return (value) =>
    Array.isArray(value) && allowPlural ? plural(value) : convert(value);
}

// Shared converters contain no application callbacks or response cache.
const emptyPlan = { version: 2, roots: { __root: [] } };
const readWithoutPlan = prepareConversion(emptyPlan, undefined, undefined);
const writeWithoutPlan = prepareConversion(emptyPlan, undefined, null);
function convertWithoutPlan(value, nullable) {
  return nullable === null ? writeWithoutPlan(value) : readWithoutPlan(value);
}

module.exports = { prepareConversion, convertWithoutPlan };
