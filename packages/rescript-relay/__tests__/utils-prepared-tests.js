const { prepareConversion, runConversion } = require("../src/utils");
const {
  object,
  list,
  scalar,
  opaque,
  reference,
  union,
  encode,
  evaluate,
  freeze,
} = require("./helpers/conversionModel");
function prepare(schema, converters = {}, nullable, extra = {}) {
  const convert = prepareConversion(
    encode({ __root: schema, ...extra }),
    converters,
    nullable,
  );
  return (value) => runConversion(convert, value);
}

describe.each([undefined, null])(
  "prepared conversion (nullable=%s)",
  (nullable) => {
    test("field boundaries cannot collide with underscores or union type names", () => {
      const schema = object({
        a_b: scalar("a"),
        a: object({ b: scalar("b") }),
        members: union("union", {
          User_Profile: object({ created_at: scalar("a") }),
        }),
      });
      const input = freeze({
        a_b: "x",
        a: { b: "y" },
        members: { __typename: "User_Profile", created_at: "z" },
      });
      const c = { a: (v) => "a:" + v, b: (v) => "b:" + v, union: (v) => v };
      expect(prepare(schema, c, nullable)(input)).toStrictEqual({
        a_b: "a:x",
        a: { b: "b:y" },
        members: { __typename: "User_Profile", created_at: "a:z" },
      });
    });

    test.each([0, 1, 2, 3])(
      "explicit list depth %i preserves array-valued scalar boundaries",
      (depth) => {
        let schema = scalar("box");
        let wire = "value";
        let expected = ["value"];
        for (let i = 0; i < depth; i++) {
          schema = list(schema);
          wire = [wire, null, undefined];
          expected = [expected, nullable, nullable];
        }
        const box = jest.fn((v) => [v]);
        const output = prepare(
          object({ value: schema }),
          { box },
          nullable,
        )(freeze({ value: wire }));
        expect(output).toStrictEqual({ value: expected });
        expect(box).toHaveBeenCalledTimes(1);
        // The opposite direction can have an array-valued scalar as its input.
        const unbox = jest.fn((v) => v[0]);
        let boxed = ["value"];
        let unboxed = "value";
        for (let i = 0; i < depth; i++) {
          boxed = [boxed, null];
          unboxed = [unboxed, nullable];
        }
        expect(
          prepare(
            object({ value: schema }),
            { box: unbox },
            nullable,
          )({ value: boxed }),
        ).toStrictEqual({ value: unboxed });
        expect(unbox).toHaveBeenCalledTimes(1);
      },
    );

    test("sparse lists, optional markers, missing keys and falsey values stay distinct", () => {
      const marker = { BS_PRIVATE_NESTED_SOME_NONE: 0 };
      const input = freeze({
        items: [null, , undefined, marker, 0, false, ""],
        marker,
        missingSibling: null,
      });
      const fn = jest.fn((v) => v);
      const output = prepare(
        object({
          items: list(scalar("scalar")),
          marker: scalar("scalar"),
          absent: scalar("scalar"),
        }),
        { scalar: fn },
        nullable,
      )(input);
      expect(output.items).toStrictEqual([
        nullable,
        ,
        nullable,
        marker,
        0,
        false,
        "",
      ]);
      expect(output.marker).toBe(marker);
      expect(output).not.toHaveProperty("absent");
      expect(fn.mock.calls).toEqual([[0], [false], [""]]);
    });

    test("nested JSON list depth differs from arrays inside JSON", () => {
      const json = freeze([null, { x: null }]);
      const input = freeze({ items: [[json, null], null] });
      const output = prepare(
        object({ items: list(list(opaque)) }),
        {},
        nullable,
      )(input);
      expect(output.items[0][0]).toBe(json);
      expect(output.items[0][1]).toBe(nullable);
      expect(output.items[1]).toBe(nullable);
    });

    test("root and nested unions run callbacks in the same order", () => {
      for (const nested of [false, true]) {
        const schema = union("union", {
          User: object({ value: scalar("scalar") }, true),
        });
        const calls = [];
        const c = {
          union: (v) => {
            calls.push("union");
            return { ...v, extra: 1 };
          },
          scalar: (v) => {
            calls.push("scalar");
            return v + 1;
          },
        };
        const input = freeze({ __typename: "User", value: 1 });
        const output = prepare(
          nested ? object({ node: schema }) : schema,
          c,
          nullable,
        )(nested ? { node: input } : input);
        const node = nested ? output.node : output;
        expect(node.value).toBe(2);
        expect(node.extra).toBe(1);
        expect(calls).toEqual(
          nullable === null ? ["union", "scalar"] : ["scalar", "union"],
        );
        expect(node.fragmentRefs.value).toBe(1);
        expect(node.updatableFragmentRefs).toBe(node.fragmentRefs);
      }
    });

    test("unknown union members, nullable members and plural roots are independent", () => {
      const schema = union("union", {
        User: object({ value: scalar("scalar") }, true),
      });
      const c = {
        union: (v) =>
          v.__typename === "User" ? v : { ...v, __typename: "__unselected" },
        scalar: (v) => v + 1,
      };
      const input = freeze([
        { __typename: "User", value: 1 },
        null,
        { __typename: "Page", value: null },
      ]);
      const output = prepare(schema, c, nullable)(input);
      expect(output[0].value).toBe(2);
      expect(output[1]).toBe(nullable);
      expect(output[2]).toStrictEqual({
        __typename: "__unselected",
        value: nullable,
      });
      expect(output[2]).not.toHaveProperty("fragmentRefs");
    });

    test("recursive references reset scope and unwrap input unions at every depth", () => {
      const definitions = {
        Tree: object({
          value: scalar("scalar"),
          children: list(reference("Tree")),
        }),
        Choice: object({ tree: reference("Tree") }),
      };
      const scalarFn = jest.fn((v) => Number(v));
      const input = freeze({
        choice: {
          __$inputUnion: "tree",
          _0: { value: "1", children: [{ value: "2", children: [] }, null] },
        },
      });
      expect(
        prepare(
          object({ choice: reference("Choice") }),
          { scalar: scalarFn },
          nullable,
          definitions,
        )(input),
      ).toStrictEqual({
        choice: {
          tree: { value: 1, children: [{ value: 2, children: [] }, nullable] },
        },
      });
      expect(scalarFn.mock.calls).toEqual([["1"], ["2"]]);
    });

    test("shared objects are converted by path, not by identity", () => {
      const shared = freeze({ value: "x" });
      const input = freeze({ a: shared, b: shared });
      expect(
        prepare(
          object({
            a: object({ value: scalar("a") }),
            b: object({ value: scalar("b") }),
          }),
          { a: (v) => "a" + v, b: (v) => "b" + v },
          nullable,
        )(input),
      ).toStrictEqual({ a: { value: "ax" }, b: { value: "bx" } });
    });

    test("scalar output and cyclic metadata remain opaque; callbacks can reenter conversion", () => {
      const cyclic = {};
      cyclic.self = cyclic;
      freeze(cyclic);
      let convert;
      const c = {
        scalar: (v) =>
          v === "outer" ? convert({ value: "inner", __owner: cyclic }) : cyclic,
      };
      convert = prepare(object({ value: scalar("scalar") }), c, nullable);
      const output = convert(freeze({ value: "outer", __owner: cyclic }));
      expect(output.value.value).toBe(cyclic);
      expect(output.__owner).toBe(cyclic);
    });

    test("callbacks follow data property order, independent of instruction order", () => {
      const schema = object({
        a: scalar("scalar"),
        b: scalar("scalar"),
        items: list(scalar("scalar")),
      });
      const plan = encode({ __root: schema });
      for (const reverse of [false, true]) {
        const c = jest.fn((v) => v + 1);
        const entries = plan.roots.__root.slice();
        if (reverse) entries.reverse();
        const convert = prepareConversion(
          { version: 2, roots: { __root: entries } },
          { scalar: c },
          nullable,
        );
        expect(
          convert(freeze({ b: 2, items: [3, null, 4], a: 1 })),
        ).toStrictEqual({ b: 3, items: [4, nullable, 5], a: 2 });
        expect(c.mock.calls).toEqual([[2], [3], [4], [1]]);
      }
    });

    test("callback errors propagate exactly and stop later siblings without source mutation", () => {
      const error = new Error("scalar failure");
      const after = jest.fn((v) => v);
      const input = freeze({ before: null, value: "bad", after: "untouched" });
      const convert = prepare(
        object({ value: scalar("fail"), after: scalar("after") }),
        {
          fail: () => {
            throw error;
          },
          after,
        },
        nullable,
      );
      expect(() => convert(input)).toThrow(error);
      expect(after).not.toHaveBeenCalled();
      expect(input.before).toBeNull();
    });
  },
);

test("prepared plans snapshot metadata and callback bindings, but not callback closure state or data", () => {
  const plan = encode({ __root: object({ value: scalar("scalar") }) });
  let offset = 1;
  const callbacks = { scalar: (v) => v + offset };
  const convert = prepareConversion(plan, callbacks, undefined);
  plan.roots.__root.length = 0;
  callbacks.scalar = () => 999;
  expect(convert({ value: 1 })).toStrictEqual({ value: 2 });
  offset = 2;
  expect(convert({ value: 1 })).toStrictEqual({ value: 3 });
});

test("unchanged branches and null-prototype dictionaries preserve data without inherited selections", () => {
  const convert = prepare(object());
  const root = freeze({ items: [{ x: 1 }], value: 0 });
  expect(convert(root)).toBe(root);
  const raw = Object.assign(Object.create(null), {
    constructor: null,
    toString: null,
  });
  expect(convert(raw)).toEqual({ constructor: undefined, toString: undefined });
  const inherited = Object.create({ hidden: null });
  inherited.value = null;
  expect(convert(inherited)).toStrictEqual({ value: undefined });
  const special = JSON.parse('{"__proto__":{"polluted":true},"value":null}');
  const output = convert(special);
  expect(Object.getPrototypeOf(output)).toBe(Object.prototype);
  expect(Object.hasOwn(output, "__proto__")).toBe(true);
  expect({}.polluted).toBeUndefined();
});

describe("prepared plan validation", () => {
  test.each([
    [null, {}, undefined, /version 2/],
    [{ version: 1, roots: {} }, {}, undefined, /version 2/],
    [{ version: 2, roots: {} }, {}, undefined, /Missing conversion root/],
    [
      { version: 2, roots: { __root: {} } },
      {},
      undefined,
      /Invalid conversion root/,
    ],
    [
      { version: 2, roots: { __root: [{}] } },
      {},
      undefined,
      /Invalid conversion path/,
    ],
    [
      { version: 2, roots: { __root: [{ path: [1] }] } },
      {},
      undefined,
      /Invalid conversion path/,
    ],
    [
      { version: 2, roots: { __root: [{ path: [], typo: true }] } },
      {},
      undefined,
      /Unknown conversion instruction/,
    ],
    [{ version: 2, roots: { __root: [] } }, {}, false, /nullable sentinel/],
    [
      { version: 2, roots: { __root: [{ path: ["x"], scalar: "toString" }] } },
      {},
      undefined,
      /Missing conversion callback/,
    ],
    [
      {
        version: 2,
        roots: { __root: [{ path: ["x"], reference: "missing" }] },
      },
      {},
      undefined,
      /Missing conversion reference/,
    ],
    [
      {
        version: 2,
        roots: {
          __root: [
            { path: ["x"], scalar: "a" },
            { path: ["x"], scalar: "b" },
          ],
        },
      },
      {},
      undefined,
      /Conflicting conversion instruction/,
    ],
  ])(
    "rejects invalid plan %# before seeing data",
    (plan, callbacks, nullable, error) => {
      expect(() => prepareConversion(plan, callbacks, nullable)).toThrow(error);
    },
  );
  test.each([
    [{ scalar: "a", opaque: true }, /Conflicting conversion operations/],
    [{ scalar: 1 }, /Invalid conversion scalar/],
    [{ union: 1 }, /Invalid conversion union/],
    [{ reference: 1 }, /Invalid conversion reference/],
    [{ opaque: false }, /Invalid conversion opaque/],
    [{ fragments: false }, /Invalid conversion fragments/],
    [{ list: -1 }, /Invalid conversion list depth/],
    [{ list: 1.5 }, /Invalid conversion list depth/],
    [{ list: "1" }, /Invalid conversion list depth/],
    [{ scalar: "a", fragments: true }, /Leaf conversion/],
    [{ union: "a", fragments: true }, /Union fragments/],
  ])("rejects conflicting or malformed operation %#", (instruction, error) => {
    expect(() =>
      prepareConversion(
        { version: 2, roots: { __root: [{ path: ["x"], ...instruction }] } },
        { a: (v) => v },
      ),
    ).toThrow(error);
  });
  test("rejects child instructions underneath opaque/scalar/reference boundaries", () => {
    expect(() =>
      prepareConversion({
        version: 2,
        roots: {
          __root: [
            { path: ["x"], opaque: true },
            { path: ["x", "child"], fragments: true },
          ],
        },
      }),
    ).toThrow(/Leaf conversion/);
  });
  test("identical entries can be repeated and explicitly named roots selected", () => {
    const entry = { path: ["x"], scalar: "a" };
    expect(
      prepareConversion(
        { version: 2, roots: { Other: [entry, entry] } },
        { a: (v) => v + 1 },
        undefined,
        "Other",
      )({ x: 1 }),
    ).toStrictEqual({ x: 2 });
  });
});

test("deterministic generated schema trees agree with independent evaluator and callback traces", () => {
  let seed = 0x941bf;
  const random = () => {
    seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
    return seed;
  };
  function generate(depth) {
    if (!depth)
      return [scalar("number"), scalar("box"), opaque, object()][random() % 4];
    switch (random() % 5) {
      case 0:
        return list(generate(depth - 1));
      case 1:
        return union("union", {
          User: object({ a_b: generate(depth - 1) }),
          Page: object({ value: generate(depth - 1) }, true),
        });
      default:
        return object(
          {
            a_b: generate(depth - 1),
            a: object({ b: generate(depth - 1) }),
            other: generate(0),
          },
          random() % 3 === 0,
        );
    }
  }
  function payload(schema) {
    const n = random() % 10;
    if (n === 0) return null;
    if (n === 1) return undefined;
    switch (schema.kind) {
      case "scalar":
        return String(random() % 100);
      case "opaque":
        return [null, { x: null }];
      case "list":
        return Array.from({ length: random() % 4 }, () => payload(schema.item));
      case "union": {
        const type = random() % 2 ? "User" : "Page";
        return { ...payload(schema.members[type]), __typename: type };
      }
      case "object":
        return Object.fromEntries(
          Object.entries(schema.fields)
            .reverse()
            .map(([key, field]) => [key, payload(field)]),
        );
    }
  }
  for (let i = 0; i < 150; i++) {
    const schema = object({ root: generate(3) });
    const input = freeze(payload(schema));
    const definitions = { __root: schema };
    const plan = freeze(encode(definitions));
    for (const nullable of [null, undefined]) {
      const actualTrace = [],
        expectedTrace = [];
      const callbacks = (trace) => ({
        number: (v) => {
          trace.push(["number", v]);
          return Number(v);
        },
        box: (v) => {
          trace.push(["box", v]);
          return [v];
        },
        union: (v) => {
          trace.push(["union", v]);
          return v;
        },
      });
      const result = prepareConversion(
        plan,
        callbacks(actualTrace),
        nullable,
      )(input);
      expect(result).toStrictEqual(
        evaluate(
          schema,
          input,
          definitions,
          callbacks(expectedTrace),
          nullable,
        ),
      );
      expect(actualTrace).toStrictEqual(expectedTrace);
    }
  }
});

test("read/write round trips retain nullable structure, nested lists and opaque scalar values", () => {
  const schema = object({
    nested: list(list(scalar("number"))),
    boxed: list(scalar("box")),
    json: opaque,
  });
  const wire = freeze({
    nested: [["1", null, "2"], null],
    boxed: ["x", null, "y"],
    json: { value: null },
  });
  const read = prepare(
    schema,
    { number: (v) => Number(v), box: (v) => [v] },
    undefined,
  );
  const write = prepare(
    schema,
    { number: (v) => String(v), box: (v) => v[0] },
    null,
  );
  const decoded = read(wire);
  expect(decoded.boxed[0]).toStrictEqual(["x"]);
  expect(write(decoded)).toStrictEqual(wire);
  expect(decoded.json).toBe(wire.json);
});

// Native scalar lists have list wrappers but no scalar callback instruction.
test("native scalar list plans preserve primitives and normalize nullable members", () => {
  const convert = prepareConversion(
    { version: 2, roots: { __root: [{ path: ["values"], list: 1 }] } },
    {},
    undefined,
  );
  const unchanged = freeze({
    values: ["long string", 0, false, "", undefined],
  });
  expect(convert(unchanged)).toBe(unchanged);
  expect(convert(freeze({ values: ["x", null, [null]] }))).toStrictEqual({
    values: ["x", undefined, [undefined]],
  });
});

describe.each([null, undefined])(
  "shared conversion without instructions (%s)",
  (nullable) => {
    test("matches ordinary preparation without retaining or mutating values", () => {
      const { convertWithoutPlan } = require("../src/utils");
      const option = { BS_PRIVATE_NESTED_SOME_NONE: 0 };
      const metadata = { opaque: null };
      const input = freeze({
        list: [null, undefined, , { value: null }, option],
        __metadata: metadata,
      });
      const expected = {
        list: [nullable, nullable, , { value: nullable }, option],
        __metadata: metadata,
      };
      expect(convertWithoutPlan(input, nullable)).toStrictEqual(expected);
      expect(convertWithoutPlan(input, nullable)).toStrictEqual(
        prepareConversion(
          { version: 2, roots: { __root: [] } },
          {},
          nullable,
        )(input),
      );
      expect(convertWithoutPlan(null, nullable)).toBe(nullable);
      expect(convertWithoutPlan([input], nullable)).toStrictEqual([expected]);
      expect(convertWithoutPlan(option, nullable)).toBe(option);
      const unchanged = freeze({ values: [0, false, "", nullable] });
      expect(convertWithoutPlan(unchanged, nullable)).toBe(unchanged);
      const mutable = { value: null };
      convertWithoutPlan(mutable, nullable);
      mutable.value = "updated";
      expect(convertWithoutPlan(mutable, nullable)).toBe(mutable);
    });
  },
);
