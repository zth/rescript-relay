open RescriptRelay_ConversionInterop

%%private(
  let empty: value = %raw(`Object.freeze({})`)
  let fallback = value =>
    if truthy(value) {
      value
    } else {
      empty
    }
  let unwrap = value =>
    if !isNullable(value) && typeOf(value) === "object" && hasProperty("__$inputUnion", value) {
      unwrapInputUnion(value)
    } else {
      value
    }
)

let rec traverser = (
  root: value,
  instructionMaps: value,
  callbacks: value,
  nullable: value,
  rootObjectKey: value,
): value => {
  if !truthy(root) {
    nullable
  } else {
    let maps = if truthy(instructionMaps) {
      instructionMaps
    } else {
      empty
    }
    let key: string = if truthy(rootObjectKey) {
      cast(rootObjectKey)
    } else {
      "__root"
    }
    let instructions = fallback(get(maps, key))
    let callbacks = if truthy(callbacks) {
      callbacks
    } else {
      empty
    }
    let rootInstruction = fallback(get(instructions, ""))
    let union: value = get(callbacks, get(rootInstruction, "u"))
    let fragment = get(rootInstruction, "f") === cast("")
    let convertRoot = value => {
      if isNullable(value) {
        nullable
      } else {
        let prefix = if !isNullable(union) {
          (get(value, "__typename"): string) ++ "_"
        } else {
          ""
        }
        let hasFragment = if !isNullable(union) {
          get(fallback(get(instructions, get(value, "__typename"))), "f") === cast("")
        } else {
          fragment
        }
        let result = legacyRecord(
          maps,
          prefix,
          value,
          instructions,
          callbacks,
          nullable,
          hasFragment,
          convertField,
        )
        if !isNullable(union) {
          (cast(union): converter)(result)
        } else {
          result
        }
      }
    }
    if isArray(root) {
      let result = ref(jsUndefined)
      let i = ref(0)
      while i.contents < length(root) {
        let index = i.contents
        if hasIndex(index, root) {
          let original = at(root, index)
          let next = convertRoot(original)
          if next !== original {
            if result.contents === jsUndefined {
              result := slice(root)
            }
            put(result.contents, index, next)
          }
        }
        i := i.contents + 1
      }
      if result.contents === jsUndefined {
        root
      } else {
        result.contents
      }
    } else {
      convertRoot(root)
    }
  }
}
and convertUnion = (value, convert: converter, maps, path, instructions, callbacks, nullable) => {
  let unionPath = path ++ "_" ++ (get(value, "__typename"): string)
  let fragment = get(fallback(get(instructions, unionPath)), "f") === cast("")
  let raw = if nullable === jsNull {
    convert(value)
  } else {
    value
  }
  let result = legacyRecord(
    maps,
    unionPath ++ "_",
    raw,
    instructions,
    callbacks,
    nullable,
    fragment,
    convertField,
  )
  if nullable === jsUndefined {
    convert(result)
  } else {
    result
  }
}
and convertField = (value, rawInstruction, maps, path, instructions, callbacks, nullable) => {
  let instruction = if truthy(rawInstruction) {
    rawInstruction
  } else {
    empty
  }
  let array = isArray(value)
  let customArray = if typeOf(get(instruction, "ca")) === "string" {
    get(callbacks, get(instruction, "ca"))
  } else {
    jsUndefined
  }
  if array && truthy(customArray) {
    map(value, (item, index, array) => {
      if isNullable(item) {
        nullable
      } else if (get(item, "BS_PRIVATE_NESTED_SOME_NONE"): float) >= 0.0 {
        item
      } else {
        (cast(customArray): (value, int, value) => value)(item, index, array)
      }
    })
  } else {
    let blocked = typeOf(get(instruction, "b")) === "string"
    if blocked && get(instruction, "b") !== cast("a") {
      value
    } else {
      let custom = if typeOf(get(instruction, "c")) === "string" {
        get(callbacks, get(instruction, "c"))
      } else {
        jsUndefined
      }
      if array && truthy(custom) {
        (cast(custom): converter)(value)
      } else {
        let root = if typeOf(get(instruction, "r")) === "string" {
          get(maps, get(instruction, "r"))
        } else {
          jsUndefined
        }
        let enumConverter = if typeOf(get(instruction, "e")) === "string" {
          get(callbacks, get(instruction, "e"))
        } else {
          jsUndefined
        }
        let union = if typeOf(get(instruction, "u")) === "string" {
          get(callbacks, get(instruction, "u"))
        } else {
          jsUndefined
        }
        let fragment = get(instruction, "f") === cast("")
        if array {
          let result = ref(jsUndefined)
          let i = ref(0)
          while i.contents < length(value) {
            let index = i.contents
            if hasIndex(index, value) {
              let item = at(value, index)
              let next = if isNullable(item) {
                nullable
              } else if truthy(root) {
                traverser(unwrap(item), maps, callbacks, nullable, get(instruction, "r"))
              } else if truthy(enumConverter) {
                (cast(enumConverter): converter)(item)
              } else if (
                truthy(union) && typeOf(item) === "object" && !isNullable(get(item, "__typename"))
              ) {
                convertUnion(item, cast(union), maps, path, instructions, callbacks, nullable)
              } else if typeOf(item) === "object" && !isArray(item) {
                if blocked {
                  if fragment {
                    withLegacyFragments(item)
                  } else {
                    item
                  }
                } else {
                  legacyRecord(
                    maps,
                    path ++ "_",
                    item,
                    instructions,
                    callbacks,
                    nullable,
                    fragment,
                    convertField,
                  )
                }
              } else {
                item
              }
              if next !== item {
                if result.contents === jsUndefined {
                  result := slice(value)
                }
                put(result.contents, index, next)
              }
            }
            i := i.contents + 1
          }
          if result.contents === jsUndefined {
            value
          } else {
            result.contents
          }
        } else if truthy(root) {
          traverser(unwrap(value), maps, callbacks, nullable, get(instruction, "r"))
        } else if truthy(custom) {
          (cast(custom): converter)(value)
        } else if truthy(enumConverter) {
          (cast(enumConverter): converter)(value)
        } else if typeOf(value) === "object" {
          if truthy(union) && !isNullable(get(value, "__typename")) {
            convertUnion(value, cast(union), maps, path, instructions, callbacks, nullable)
          } else {
            legacyRecord(
              maps,
              path ++ "_",
              value,
              instructions,
              callbacks,
              nullable,
              fragment,
              convertField,
            )
          }
        } else {
          value
        }
      }
    }
  }
}
