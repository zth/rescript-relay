function getNewObj(maybeNewObj, currentObj) {
  return maybeNewObj || Object.assign({}, currentObj);
}

function getPathName(path) {
  return path.join("_");
}

function makeNewPath(currentPath, newKeys) {
  return [].concat(currentPath, newKeys);
}

function getTypename(v) {
  if (v != null && typeof v === "object" && v.__typename != null) {
    return v.__typename;
  }
}

function unwrapInputUnion(obj) {
  if (obj != null && typeof obj === "object" && "__$inputUnion" in obj) {
    return {
      [obj["__$inputUnion"]]: obj["_0"],
    };
  }

  return obj;
}

/**
 * Runs on each object in the tree and follows the provided instructions
 * to apply transforms etc.
 */
function traverse(
  fullInstructionMap,
  currentPath,
  currentObj,
  instructionMap,
  converters,
  nullableValue,
  instructionPaths,
  addFragmentOnRoot
) {
  // We lazily set up a new object for each "level", as we don't want to mutate
  // what comes back from the Relay store, and nor do we want to create new
  // objects unless we need to. And we only need to when we need to change
  // something.
  var newObj;

  if (addFragmentOnRoot) {
    newObj = getNewObj(newObj, currentObj);
    newObj.fragmentRefs = Object.assign({}, newObj);
  }

  for (var key in currentObj) {
    // Ensure we don't move into internal properties coming from Relay, with the
    // exception of the few names allowed to start with double underscores
    // ("__typename" and "__id"), and any Relay provided variables.
    if (
      key.startsWith("__") &&
      key !== "__typename" &&
      key !== "__id" &&
      !key.startsWith("__relay_internal")
    )
      continue;

    var isUnion = false;
    var originalValue = currentObj[key];

    // Instructions are stored by the path in the object where they apply
    var thisPath = makeNewPath(currentPath, [key]);
    var path = getPathName(thisPath);

    var instructions = instructionMap[path] || {};

    if (currentObj[key] == null) {
      newObj = getNewObj(newObj, currentObj);
      newObj[key] = nullableValue;
      continue;
    }

    var shouldConvertRootObj =
      typeof instructions["r"] === "string" &&
      fullInstructionMap[instructions["r"]];

    var shouldAddFragmentFn = instructions["f"] === "";

    var shouldConvertEnum =
      typeof instructions["e"] === "string" && !!converters[instructions["e"]];

    // This is true for non-arrays that are to be converted
    var shouldConvertCustomField =
      typeof instructions["c"] === "string" && !!converters[instructions["c"]];

    // This is true for arrays that are to be converted. This and the above
    // won't be true at the same time.
    var shouldConvertCustomFieldArray =
      typeof instructions["ca"] === "string" &&
      !!converters[instructions["ca"]];

    // Special case when this is a custom field that's an array. Ensures we
    // don't accidentally move into the array when we're not supposed to.
    if (shouldConvertCustomFieldArray && Array.isArray(currentObj[key])) {
      newObj = getNewObj(newObj, currentObj);
      newObj[key] = currentObj[key].map(converters[instructions["ca"]]);
      return newObj;
    }

    var shouldBlockTraversal = typeof instructions["b"] === "string";
    var allowGoingIntoArray = shouldBlockTraversal
      ? instructions["b"] === "a"
      : true;

    if (shouldBlockTraversal && !allowGoingIntoArray) {
      newObj = getNewObj(newObj, currentObj);
      continue;
    }

    var shouldConvertUnion =
      typeof instructions["u"] === "string" && !!converters[instructions["u"]];

    /**
     * Handle arrays
     */

    // Special case when this is a custom field that's an array. Ensures we
    // don't accidentally move into the array when we're not supposed to.
    if (shouldConvertCustomField && Array.isArray(currentObj[key])) {
      newObj = getNewObj(newObj, currentObj);
      newObj[key] = converters[instructions["c"]](originalValue);
      return newObj;
    }

    if (Array.isArray(currentObj[key])) {
      newObj = getNewObj(newObj, currentObj);
      newObj[key] = currentObj[key].map(function (v) {
        if (v == null) {
          return nullableValue;
        }
        if (shouldConvertRootObj) {
          return traverser(
            unwrapInputUnion(v),
            fullInstructionMap,
            converters,
            nullableValue,
            instructions["r"]
          );
        }

        if (shouldConvertEnum) {
          return converters[instructions["e"]](v);
        }

        if (shouldConvertCustomField) {
          return converters[instructions["c"]](v);
        }

        if (shouldConvertUnion && v != null && typeof v === "object") {
          var typename = getTypename(v);

          if (typename != null) {
            isUnion = true;
            var unionObj = v;

            // Means we're wrapping, and this will be a ReScript value.
            if (nullableValue === null) {
              // Convert it back to a flat JS value
              unionObj = converters[instructions["u"]](v);
            }

            var newPath = makeNewPath(currentPath, [key, typename]);

            var unionRootHasFragment =
              (instructionMap[getPathName(newPath)] || {}).f === "";

            var traversedValue = traverse(
              fullInstructionMap,
              newPath,
              unionObj,
              instructionMap,
              converters,
              nullableValue,
              instructionPaths,
              unionRootHasFragment
            );

            // Undefined means we're going from JS to ReScript, in which case we
            // need to run the conversion here rather than earlier.
            return nullableValue === undefined
              ? converters[instructions["u"]](traversedValue)
              : traversedValue;
          }
        }

        if (shouldAddFragmentFn && typeof v === "object" && !Array.isArray(v)) {
          var objWithFragmentFn = Object.assign({}, v);
          objWithFragmentFn.fragmentRefs = Object.assign({}, objWithFragmentFn);
          return objWithFragmentFn;
        }

        return v;
      });
    } else {
      /**
       * Handle normal values.
       */
      var v = currentObj[key];

      if (shouldConvertRootObj) {
        newObj = getNewObj(newObj, currentObj);
        newObj[key] = traverser(
          unwrapInputUnion(v),
          fullInstructionMap,
          converters,
          nullableValue,
          instructions["r"]
        );
        continue;
      }

      if (shouldConvertEnum) {
        newObj = getNewObj(newObj, currentObj);
        newObj[key] = converters[instructions["e"]](v);
      }

      if (shouldConvertCustomField) {
        newObj = getNewObj(newObj, currentObj);
        newObj[key] = converters[instructions["c"]](v);
        // Ensure that the custom scalar value itself isn't traversed more.
        continue;
      }

      if (shouldConvertUnion && v != null && typeof v === "object") {
        var typename = getTypename(v);

        if (typename != null) {
          isUnion = true;
          var unionObj = v;

          // Means we're wrapping, and this will be a ReScript value.
          if (nullableValue === null) {
            // Convert it back to a flat JS value
            unionObj = converters[instructions["u"]](v);
          }

          var newPath = makeNewPath(currentPath, [key, typename]);

          var unionRootHasFragment =
            (instructionMap[getPathName(newPath)] || {}).f === "";

          var traversedValue = traverse(
            fullInstructionMap,
            newPath,
            unionObj,
            instructionMap,
            converters,
            nullableValue,
            instructionPaths,
            unionRootHasFragment
          );

          newObj = getNewObj(newObj, currentObj);

          newObj[key] =
            // Undefined means we're going from JS to ReScript, in which case we
            // need to run the conversion here rather than earlier.
            nullableValue === undefined
              ? converters[instructions["u"]](traversedValue)
              : traversedValue;
        }
      }

      if (shouldAddFragmentFn && typeof v === "object" && !Array.isArray(v)) {
        newObj = getNewObj(newObj, currentObj);
        var objWithFragmentFn = Object.assign({}, v);
        objWithFragmentFn.fragmentRefs = Object.assign({}, objWithFragmentFn);
        newObj[key] = objWithFragmentFn;
      }
    }

    if (originalValue != null && !isUnion) {
      var nextObj = (newObj && newObj[key]) || currentObj[key];

      if (typeof nextObj === "object" && !Array.isArray(originalValue)) {
        var traversedObj = traverse(
          fullInstructionMap,
          thisPath,
          nextObj,
          instructionMap,
          converters,
          nullableValue,
          instructionPaths
        );

        if (traversedObj !== nextObj) {
          newObj = getNewObj(newObj, currentObj);
          newObj[key] = traversedObj;
        }
      } else if (Array.isArray(originalValue) && !shouldBlockTraversal) {
        newObj = getNewObj(newObj, currentObj);
        newObj[key] = nextObj.map(function (o) {
          if (typeof o === "object" && o != null && !Array.isArray(o)) {
            return traverse(
              fullInstructionMap,
              thisPath,
              o,
              instructionMap,
              converters,
              nullableValue,
              instructionPaths
            );
          } else if (o == null) {
            return nullableValue;
          } else {
            return o;
          }
        });
      }
    }
  }

  return newObj || currentObj;
}

/**
 * This function takes an object (snapshot from the Relay store) and applies a
 * set of conversions deeply on the object (instructions coming from "converters"-prop).
 * It converts nullable values either to null or undefined, and it wraps/unwraps enums
 * and unions.
 *
 * It preserves structural integrity where possible, and return new objects where properties
 * have been modified.
 */
function traverser(
  root,
  instructionMaps_,
  theConverters,
  nullableValue,
  rootObjectKey
) {
  if (!root) {
    return nullableValue;
  }

  var instructionMaps = instructionMaps_ || {};
  var instructionMap = instructionMaps[rootObjectKey || "__root"] || {};

  var converters = theConverters == null ? {} : theConverters;
  var instructionPaths = Object.keys(instructionMap);

  // We'll add the fragmentRefs reference to the root if needed here.
  var fragmentsOnRoot = (instructionMap[""] || {}).f === "";
  var unionRootConverter = converters[(instructionMap[""] || {}).u];

  if (Array.isArray(root)) {
    return root.map(function (v) {
      if (v == null) {
        return nullableValue;
      }

      var n = [];

      // Since a root level union is treated as a "new root level", we'll need
      // to do a separate check here of whether there's a fragment on the root
      // we need to account for, or not.
      if (unionRootConverter != null) {
        n = [v.__typename];
        fragmentsOnRoot = (instructionMap[v.__typename] || {}).f === "";
      }

      var traversedObj = traverse(
        instructionMaps,
        n,
        v,
        instructionMap,
        converters,
        nullableValue,
        instructionPaths,
        fragmentsOnRoot
      );

      return unionRootConverter != null
        ? unionRootConverter(traversedObj)
        : traversedObj;
    });
  }

  var newObj = Object.assign({}, root);

  var n = [];

  // Same as in the union array check above - if there's a fragment in the new
  // root created by the union, we need to account for that separately here.
  if (unionRootConverter != null) {
    n = [newObj.__typename];
    fragmentsOnRoot = (instructionMap[newObj.__typename] || {}).f === "";
  }

  var v = traverse(
    instructionMaps,
    n,
    newObj,
    instructionMap,
    converters,
    nullableValue,
    instructionPaths,
    fragmentsOnRoot
  );

  return unionRootConverter != null ? unionRootConverter(v) : v;
}

module.exports = { traverser };
