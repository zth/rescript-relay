function getNewObj(maybeNewObj, currentObj) {
  return maybeNewObj || Object.assign({}, currentObj);
}

function getPathName(path) {
  return path.join("_");
}

function makeNewPath(currentPath, newKeys) {
  return [].concat(currentPath, newKeys);
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
  var newObj;

  if (addFragmentOnRoot) {
    newObj = getNewObj(newObj, currentObj);
    newObj.fragmentRefs = Object.assign({}, newObj);
  }

  for (var key in currentObj) {
    var isUnion = false;
    var originalValue = currentObj[key];

    // Instructions are stored by the path in the object where they apply
    var thisPath = makeNewPath(currentPath, [key]);
    var path = getPathName(thisPath);

    var instructions = instructionMap[path];

    var hasDeeperInstructions =
      instructionPaths.filter(function (p) {
        return p.indexOf(path) === 0 && p.length > path.length;
      }).length > 0;

    if (instructions) {
      if (currentObj[key] == null) {
        if (instructions["n"] === "") {
          newObj = getNewObj(newObj, currentObj);
          newObj[key] = nullableValue;
        }
      } else {
        var shouldConvertRootObj =
          typeof instructions["r"] === "string" &&
          fullInstructionMap[instructions["r"]];

        var shouldAddFragmentFn = instructions["f"] === "";

        var shouldConvertEnum =
          typeof instructions["e"] === "string" &&
          !!converters[instructions["e"]];

        var shouldConvertCustomField =
          typeof instructions["c"] === "string" &&
          !!converters[instructions["c"]];

        var shouldConvertUnion =
          typeof instructions["u"] === "string" &&
          !!converters[instructions["u"]];

        var isTopLevelNodeField = typeof instructions["tnf"] === "string";

        /**
         * Handle arrays
         */
        if (Array.isArray(currentObj[key])) {
          newObj = getNewObj(newObj, currentObj);
          newObj[key] = currentObj[key].map(function (v) {
            if (v == null) {
              return nullableValue;
            }

            if (shouldConvertRootObj) {
              return traverser(
                v,
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

            if (
              shouldConvertUnion &&
              typeof v === "object" &&
              typeof v.__typename === "string"
            ) {
              isUnion = true;

              var newPath = makeNewPath(currentPath, [key, v.__typename]);

              var unionRootHasFragment =
                (instructionMap[getPathName(newPath)] || {}).f === "";

              var traversedValue = traverse(
                fullInstructionMap,
                newPath,
                v,
                instructionMap,
                converters,
                nullableValue,
                instructionPaths,
                unionRootHasFragment
              );

              return converters[instructions["u"]](traversedValue);
            }

            if (shouldAddFragmentFn && typeof v === "object") {
              var objWithFragmentFn = Object.assign({}, v);
              objWithFragmentFn.fragmentRefs = Object.assign(
                {},
                objWithFragmentFn
              );
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
              v,
              fullInstructionMap,
              converters,
              nullableValue,
              instructions["r"]
            );
          }

          if (isTopLevelNodeField) {
            if (
              !v ||
              !v.hasOwnProperty("__typename") ||
              v.__typename !== instructions["tnf"]
            ) {
              newObj = getNewObj(newObj, currentObj);
              newObj[key] = nullableValue;
            }
          }

          if (shouldConvertEnum) {
            newObj = getNewObj(newObj, currentObj);
            newObj[key] = converters[instructions["e"]](v);
          }

          if (shouldConvertCustomField) {
            newObj = getNewObj(newObj, currentObj);
            newObj[key] = converters[instructions["c"]](v);
          }

          if (
            shouldConvertUnion &&
            typeof v === "object" &&
            typeof v.__typename === "string"
          ) {
            isUnion = true;

            var newPath = makeNewPath(currentPath, [key, v.__typename]);

            var unionRootHasFragment =
              (instructionMap[getPathName(newPath)] || {}).f === "";

            var traversedValue = traverse(
              fullInstructionMap,
              newPath,
              v,
              instructionMap,
              converters,
              nullableValue,
              instructionPaths,
              unionRootHasFragment
            );

            newObj = getNewObj(newObj, currentObj);
            newObj[key] = converters[instructions["u"]](traversedValue);
          }

          if (shouldAddFragmentFn && typeof v === "object") {
            newObj = getNewObj(newObj, currentObj);

            var objWithFragmentFn = Object.assign({}, v);

            objWithFragmentFn.fragmentRefs = Object.assign(
              {},
              objWithFragmentFn
            );

            newObj[key] = objWithFragmentFn;
          }
        }
      }
    }

    if (hasDeeperInstructions && originalValue != null && !isUnion) {
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
      } else if (Array.isArray(originalValue)) {
        newObj = getNewObj(newObj, currentObj);
        newObj[key] = nextObj.map(function (o) {
          return typeof o === "object" && o != null
            ? traverse(
                fullInstructionMap,
                thisPath,
                o,
                instructionMap,
                converters,
                nullableValue,
                instructionPaths
              )
            : o;
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
  var instructionMap = instructionMaps[rootObjectKey || "__root"];

  // No instructions
  if (!instructionMap) {
    return root;
  }

  var converters = theConverters == null ? {} : theConverters;
  var instructionPaths = Object.keys(instructionMap);

  // Nothing to convert, bail early
  if (instructionPaths.length === 0) {
    return root;
  }

  // We'll add the fragmentRefs reference to the root if needed here.
  var fragmentsOnRoot = (instructionMap[""] || {}).f === "";
  var unionRootConverter = converters[(instructionMap[""] || {}).u];

  if (Array.isArray(root)) {
    return root.map(function (v) {
      if (v == null) {
        return nullableValue;
      }

      var n = unionRootConverter != null ? [v.__typename] : [];

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

  var n = unionRootConverter != null ? [newObj.__typename] : [];

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
