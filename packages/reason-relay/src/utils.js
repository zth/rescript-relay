function traverse(
  currentPath,
  currentObj,
  instructionMap,
  converters,
  nullableValue,
  instructionPaths
) {
  var newObj = Object.assign({}, currentObj);
  var hasChanges = false;

  for (var key in currentObj) {
    var isUnion = false;
    var originalValue = currentObj[key];

    // Instructions are stored by the path in the object where they apply
    var thisPath = [].concat(currentPath, [key]);
    var path = thisPath.join("_");

    var instructions = instructionMap[path];

    var hasDeeperInstructions =
      instructionPaths.filter(function(p) {
        return p.indexOf(path) === 0 && p.length > path.length;
      }).length > 0;

    (instructions || []).forEach(function(instruction) {
      var action = instruction[0];
      var value = instruction[1];

      switch (action) {
        // Convert nullable
        case 0: {
          if (currentObj[key] == null) {
            hasChanges = true;
            newObj[key] = nullableValue;
          }

          break;
        }

        // Convert nullable items in array
        case 1: {
          if (Array.isArray(currentObj[key])) {
            hasChanges = true;
            newObj[key] = currentObj[key].map(function(v) {
              return v == null ? nullableValue : v;
            });
          }

          break;
        }

        // Enum conversion
        case 2: {
          if (currentObj[key] != null && converters[value]) {
            hasChanges = true;

            if (Array.isArray(currentObj[key])) {
              newObj[key] = currentObj[key].map(function(v) {
                return v == null ? nullableValue : converters[value](v);
              });
            } else {
              newObj[key] = converters[value](currentObj[key]);
            }
          }

          break;
        }

        // Union conversion
        case 3: {
          if (currentObj[key] != null && converters[value]) {
            hasChanges = true;
            isUnion = true;

            if (Array.isArray(currentObj[key])) {
              newObj[key] = currentObj[key].map(function(v) {
                /**
                 * Unions are special. Since their
                 */

                if (v == null) {
                  return nullableValue;
                }

                var traversedValue = traverse(
                  [].concat(currentPath, [key, v.__typename.toLowerCase()]),
                  v,
                  instructionMap,
                  converters,
                  nullableValue,
                  instructionPaths
                );

                return converters[value](traversedValue);
              });
            } else {
              var traversedValue = traverse(
                [].concat(currentPath, [
                  key,
                  currentObj[key].__typename.toLowerCase()
                ]),
                currentObj[key],
                instructionMap,
                converters,
                nullableValue,
                instructionPaths
              );

              newObj[key] = converters[value](traversedValue);
            }
          }

          break;
        }
      }
    });

    if (hasDeeperInstructions && originalValue != null && !isUnion) {
      if (
        typeof currentObj[key] === "object" &&
        !Array.isArray(originalValue)
      ) {
        var traversedObj = traverse(
          thisPath,
          currentObj[key],
          instructionMap,
          converters,
          nullableValue,
          instructionPaths
        );

        if (traversedObj !== currentObj[key]) {
          hasChanges = true;
          newObj[key] = traversedObj;
        }
      } else if (Array.isArray(originalValue)) {
        hasChanges = true;
        newObj[key] = currentObj[key].map(function(o) {
          return typeof o === "object" && o != null
            ? traverse(
                thisPath,
                o,
                instructionMap,
                converters,
                nullableValue,
                instructionPaths
              )
            : v;
        });
      }
    }
  }

  return hasChanges ? newObj : currentObj;
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
function traverser(root, _instructionMap, converters, nullableValue) {
  if (!root) {
    return nullableValue;
  }

  var instructionMap = _instructionMap || {};
  var instructionPaths = Object.keys(instructionMap);

  // Nothing to convert, bail early
  if (instructionPaths.length === 0) {
    return root;
  }

  if (Array.isArray(root)) {
    return root.map(function(v) {
      return v == null
        ? nullableValue
        : traverse(
            [],
            v,
            instructionMap,
            converters,
            nullableValue,
            instructionPaths
          );
    });
  }

  var newObj = Object.assign({}, root);

  var v = traverse(
    [],
    newObj,
    instructionMap,
    converters,
    nullableValue,
    instructionPaths
  );

  return v;
}

module.exports = { traverser };
