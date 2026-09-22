open RescriptRelay_ConversionInterop

type rec node = {children: dict<node>, instructions: dict<value>}

%%private(
  let isOption = value => (get(value, "BS_PRIVATE_NESTED_SOME_NONE"): float) >= 0.0
  let isMetadata = key =>
    key->startsWith("__") &&
    key !== "__typename" &&
    key !== "__id" &&
    !(key->startsWith("__relay_internal"))
  let makeNode = () => {children: create(), instructions: create()}
  let readPlan = plan => {
    let rawRoots: value = if truthy(plan) {
      get(plan, "roots")
    } else {
      jsUndefined
    }
    if (
      !truthy(plan) ||
      get(plan, "version") !== cast(2) ||
      !truthy(rawRoots) ||
      typeOf(rawRoots) !== "object"
    ) {
      fail("Invalid conversion plan: expected version 2 and roots")
    }
    let roots = create()
    let rootNames = keys(rawRoots)
    for rootIndex in 0 to Array.length(rootNames) - 1 {
      let name = unsafeAt(rootNames, rootIndex)
      let entries: value = get(rawRoots, name)
      if !isArray(entries) {
        fail("Invalid conversion root: " ++ name)
      }
      let root = makeNode()
      set(roots, name, root)
      for i in 0 to length(entries) - 1 {
        let entry = at(entries, i)
        let path: value = if truthy(entry) {
          get(entry, "path")
        } else {
          jsUndefined
        }
        if !isArray(path) {
          fail("Invalid conversion path in " ++ name)
        }
        let target = ref(root)
        for j in 0 to length(path) - 1 {
          let rawKey = at(path, j)
          if typeOf(rawKey) !== "string" {
            fail("Invalid conversion path in " ++ name)
          }
          let key: string = cast(rawKey)
          if hasOwn(target.contents.children, key) {
            target := get(target.contents.children, key)
          } else {
            let child = makeNode()
            set(target.contents.children, key, child)
            target := child
          }
        }
        let instructionKeys = keys(entry)
        for keyIndex in 0 to Array.length(instructionKeys) - 1 {
          let key = unsafeAt(instructionKeys, keyIndex)
          switch key {
          | "path" => ()
          | "list" | "scalar" | "union" | "reference" | "opaque" | "fragments" =>
            let value: value = get(entry, key)
            if (
              hasOwn(target.contents.instructions, key) &&
              get(target.contents.instructions, key) !== value
            ) {
              fail("Conflicting conversion instruction: " ++ key)
            }
            set(target.contents.instructions, key, value)
          | _ => fail("Unknown conversion instruction: " ++ key)
          }
        }
      }
    }
    roots
  }
)

let prepareConversion = (
  plan: value,
  callbacks: value,
  nullable: value,
  rawRootName: value,
): converter => {
  if nullable !== jsUndefined && nullable !== jsNull {
    fail("Invalid conversion nullable sentinel")
  }
  let rootName: string = if rawRootName === jsUndefined {
    "__root"
  } else {
    cast(rawRootName)
  }
  let roots = readPlan(plan)
  if !hasOwn(roots, rootName) {
    fail("Missing conversion root: " ++ rootName)
  }
  let converters: dict<converter> = create()
  let arrayOf = (convert: converter): converter =>
    values => {
      let result = ref(jsUndefined)
      for i in 0 to length(values) - 1 {
        if hasIndex(i, values) {
          let value = at(values, i)
          let next = convert(value)
          if next !== value {
            if result.contents === jsUndefined {
              result := slice(values)
            }
            put(result.contents, i, next)
          }
        }
      }
      if result.contents === jsUndefined {
        values
      } else {
        result.contents
      }
    }
  let nullableOnly: converter = value =>
    if isNullable(value) {
      nullable
    } else {
      value
    }
  let optional = (convert: converter) => {
    if convert === nullableOnly {
      nullableOnly
    } else {
      value =>
        if isNullable(value) {
          nullable
        } else if isOption(value) {
          value
        } else {
          convert(value)
        }
    }
  }
  let rec any: converter = value => {
    if isNullable(value) {
      nullable
    } else if typeOf(value) !== "object" || isOption(value) {
      value
    } else if isArray(value) {
      anyArray(value)
    } else {
      plainRecord(value, any, isMetadata)
    }
  }
  and anyArray: converter = values => {
    let result = ref(jsUndefined)
    for i in 0 to length(values) - 1 {
      if hasIndex(i, values) {
        let value = at(values, i)
        let next = any(value)
        if next !== value {
          if result.contents === jsUndefined {
            result := slice(values)
          }
          put(result.contents, i, next)
        }
      }
    }
    if result.contents === jsUndefined {
      values
    } else {
      result.contents
    }
  }
  let callback = name => {
    if (
      !truthy(callbacks) || !hasOwn(callbacks, name) || typeOf(get(callbacks, name)) !== "function"
    ) {
      fail("Missing conversion callback: " ++ name)
    }
    (get(callbacks, name): converter)
  }
  let rec compile = node => {
    let ops = node.instructions
    let operations = ["scalar", "union", "reference"]->Array.filter(key => hasOwn(ops, key))
    let allOperations = if hasOwn(ops, "opaque") {
      Array.concat(operations, ["opaque"])
    } else {
      operations
    }
    if Array.length(allOperations) > 1 {
      fail("Conflicting conversion operations: " ++ Array.join(allOperations, ", "))
    }
    for operationIndex in 0 to Array.length(operations) - 1 {
      let key = unsafeAt(operations, operationIndex)
      if typeOf(get(ops, key)) !== "string" {
        fail("Invalid conversion " ++ key)
      }
    }
    let flags = ["opaque", "fragments"]
    for flagIndex in 0 to Array.length(flags) - 1 {
      let key = unsafeAt(flags, flagIndex)
      if hasOwn(ops, key) && get(ops, key) !== cast(true) {
        fail("Invalid conversion " ++ key)
      }
    }
    let rawDepth: value = get(ops, "list")
    let depth: int = if rawDepth === jsUndefined {
      0
    } else {
      cast(rawDepth)
    }
    if !isSafeInteger(cast(depth)) || depth < 0 {
      fail("Invalid conversion list depth")
    }
    let names = keys(node.children)
    let scalar: value = get(ops, "scalar")
    let reference: value = get(ops, "reference")
    let opaque = get(ops, "opaque") === cast(true)
    let fragments = get(ops, "fragments") === cast(true)
    let base = if scalar !== jsUndefined || opaque || reference !== jsUndefined {
      if Array.length(names) > 0 || fragments {
        fail("Leaf conversion cannot have child fields or fragments")
      }
      if scalar !== jsUndefined {
        callback(cast(scalar))
      } else if opaque {
        nullableOnly
      } else {
        let target: string = cast(reference)
        if !hasOwn(roots, target) {
          fail("Missing conversion reference: " ++ target)
        }
        value =>
          (get(converters, target): converter)(
            if hasOwn(value, "__$inputUnion") {
              unwrapInputUnion(value)
            } else {
              value
            },
          )
      }
    } else {
      let children: dict<converter> = create()
      for childIndex in 0 to Array.length(names) - 1 {
        let name = unsafeAt(names, childIndex)
        set(children, name, compile(get(node.children, name)))
      }
      let union: value = get(ops, "union")
      if union !== jsUndefined {
        if fragments {
          fail("Union fragments belong on member plans")
        }
        let union = callback(cast(union))
        let member = value => {
          let convert: converter = get(children, get(value, "__typename"))
          if cast(convert) === jsUndefined {
            any
          } else {
            convert
          }
        }
        if nullable === jsNull {
          value => member(value)(union(value))
        } else {
          value => union(member(value)(value))
        }
      } else if Array.length(names) === 0 && !fragments {
        any
      } else {
        makeRecord(children, fragments, any, isMetadata)
      }
    }
    let convert = ref(optional(base))
    for _i in 1 to depth {
      convert := optional(arrayOf(convert.contents))
    }
    convert.contents
  }
  let rootNames = keys(roots)
  for rootIndex in 0 to Array.length(rootNames) - 1 {
    let name = unsafeAt(rootNames, rootIndex)
    set(converters, name, compile(get(roots, name)))
  }
  let convert: converter = get(converters, rootName)
  let plural = arrayOf(convert)
  let root: node = get(roots, rootName)
  let allowPlural =
    get(root.instructions, "list") === jsUndefined &&
    get(root.instructions, "scalar") === jsUndefined &&
    get(root.instructions, "reference") === jsUndefined &&
    get(root.instructions, "opaque") !== cast(true)
  value =>
    if isArray(value) && allowPlural {
      plural(value)
    } else {
      convert(value)
    }
}

%%private(
  let emptyPlan: value = %raw(json`{"version":2,"roots":{"__root":[]}}`)
  let readWithoutPlan = prepareConversion(emptyPlan, jsUndefined, jsUndefined, jsUndefined)
  let writeWithoutPlan = prepareConversion(emptyPlan, jsUndefined, jsNull, jsUndefined)
)
let convertWithoutPlan = (value, nullable) =>
  if nullable === jsNull {
    writeWithoutPlan(value)
  } else {
    readWithoutPlan(value)
  }
