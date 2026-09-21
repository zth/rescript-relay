const { prepareConversion } = require("./prepareConversion");

// Shared read-only fallback: avoid allocating an empty map for every field.
var empty = Object.freeze({});

function unwrapInputUnion(obj) {
  if (obj != null && typeof obj === "object" && "__$inputUnion" in obj) {
    return { [obj["__$inputUnion"]]: obj._0 };
  }
  return obj;
}

function withFragmentRefs(obj) {
  var result = Object.assign({}, obj);
  // Both refs describe the original Relay snapshot, before conversions.
  result.fragmentRefs = Object.assign({}, obj);
  result.updatableFragmentRefs = result.fragmentRefs;
  return result;
}

function traverse(
  maps,
  prefix,
  obj,
  instructions,
  converters,
  nullable,
  fragment,
) {
  var result = fragment ? withFragmentRefs(obj) : undefined;
  for (var key in obj) {
    // Relay metadata may contain cycles and must remain opaque.
    if (
      key.startsWith("__") &&
      key !== "__typename" &&
      key !== "__id" &&
      !key.startsWith("__relay_internal")
    )
      continue;

    var value = obj[key];
    var converted;
    if (value == null) {
      converted = nullable;
    } else if (value.BS_PRIVATE_NESTED_SOME_NONE >= 0) {
      continue;
    } else {
      // Carry the encoded prefix rather than allocating and joining path arrays.
      var path = prefix + key;
      var instruction = instructions[path];
      // Most selected scalar fields need no conversion.
      if (instruction === undefined && typeof value !== "object") continue;
      instruction = instruction || empty;
      converted = convertField(
        value,
        instruction,
        maps,
        path,
        instructions,
        converters,
        nullable,
      );
    }
    if (converted !== value) {
      if (result === undefined) result = Object.assign({}, obj);
      result[key] = converted;
    }
  }
  return result === undefined ? obj : result;
}

function convertUnion(
  value,
  convert,
  maps,
  path,
  instructions,
  converters,
  nullable,
) {
  var unionPath = path + "_" + value.__typename;
  var fragment = (instructions[unionPath] || empty).f === "";
  var raw = nullable === null ? convert(value) : value;
  var result = traverse(
    maps,
    unionPath + "_",
    raw,
    instructions,
    converters,
    nullable,
    fragment,
  );
  return nullable === undefined ? convert(result) : result;
}

function convertField(
  value,
  instruction,
  maps,
  path,
  instructions,
  converters,
  nullable,
) {
  var isArray = Array.isArray(value);
  var customArray =
    typeof instruction.ca === "string" && converters[instruction.ca];
  if (isArray && customArray) {
    // GraphQL null elements belong to the list wrapper, not the scalar parser.
    return value.map((item, index, array) => {
      if (item == null) return nullable;
      if (item.BS_PRIVATE_NESTED_SOME_NONE >= 0) return item;
      return customArray(item, index, array);
    });
  }
  var blocked = typeof instruction.b === "string";
  if (blocked && instruction.b !== "a") return value;

  var custom = typeof instruction.c === "string" && converters[instruction.c];
  // A scalar can itself be represented by an array. Its result is always opaque.
  if (isArray && custom) return custom(value);

  var root = typeof instruction.r === "string" && maps[instruction.r];
  var enumConverter =
    typeof instruction.e === "string" && converters[instruction.e];
  var union = typeof instruction.u === "string" && converters[instruction.u];
  var fragment = instruction.f === "";

  if (isArray) {
    var result;
    for (var i = 0; i < value.length; i++) {
      // Match map's handling of sparse arrays.
      if (!(i in value)) continue;
      var item = value[i];
      var converted = item;
      if (item == null) {
        converted = nullable;
      } else if (root) {
        converted = traverser(
          unwrapInputUnion(item),
          maps,
          converters,
          nullable,
          instruction.r,
        );
      } else if (enumConverter) {
        converted = enumConverter(item);
      } else if (union && typeof item === "object" && item.__typename != null) {
        converted = convertUnion(
          item,
          union,
          maps,
          path,
          instructions,
          converters,
          nullable,
        );
      } else if (typeof item === "object" && !Array.isArray(item)) {
        converted = blocked
          ? fragment
            ? withFragmentRefs(item)
            : item
          : traverse(
              maps,
              path + "_",
              item,
              instructions,
              converters,
              nullable,
              fragment,
            );
      }
      if (converted !== item) {
        if (result === undefined) result = value.slice();
        result[i] = converted;
      }
    }
    return result === undefined ? value : result;
  }

  if (root)
    return traverser(
      unwrapInputUnion(value),
      maps,
      converters,
      nullable,
      instruction.r,
    );
  if (custom) return custom(value);
  if (enumConverter) return enumConverter(value);
  if (typeof value === "object") {
    if (union && value.__typename != null) {
      return convertUnion(
        value,
        union,
        maps,
        path,
        instructions,
        converters,
        nullable,
      );
    }
    return traverse(
      maps,
      path + "_",
      value,
      instructions,
      converters,
      nullable,
      fragment,
    );
  }
  return value;
}

/**
 * Convert Relay snapshots (nullable=undefined) or write payloads (nullable=null).
 * Instructions and converters are read on each call; neither they nor payloads
 * are cached or mutated. Unchanged branches retain their original identity.
 */
function traverser(root, instructionMaps, converters, nullable, rootObjectKey) {
  if (!root) return nullable;
  var maps = instructionMaps || empty;
  var instructions = maps[rootObjectKey || "__root"] || empty;
  converters = converters || empty;
  var rootInstruction = instructions[""] || empty;
  var union = converters[rootInstruction.u];
  var fragment = rootInstruction.f === "";

  function convertRoot(value) {
    if (value == null) return nullable;
    var prefix = "";
    var hasFragment = fragment;
    if (union != null) {
      prefix = value.__typename + "_";
      hasFragment = (instructions[value.__typename] || empty).f === "";
    }
    var result = traverse(
      maps,
      prefix,
      value,
      instructions,
      converters,
      nullable,
      hasFragment,
    );
    return union != null ? union(result) : result;
  }

  if (Array.isArray(root)) {
    var result;
    for (var i = 0; i < root.length; i++) {
      if (!(i in root)) continue;
      var converted = convertRoot(root[i]);
      if (converted !== root[i]) {
        if (result === undefined) result = root.slice();
        result[i] = converted;
      }
    }
    return result === undefined ? root : result;
  }
  return convertRoot(root);
}

function runConversion(convert, value) {
  return convert(value);
}

module.exports = { traverser, prepareConversion, runConversion };
