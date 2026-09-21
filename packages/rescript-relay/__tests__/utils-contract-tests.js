const { traverser } = require("../src/utils");

function freeze(value) {
  if (value && typeof value === "object" && !Object.isFrozen(value)) {
    Object.values(value).forEach(freeze);
    Object.freeze(value);
  }
  return value;
}

describe.each([undefined, null])(
  "conversion contract (nullable=%s)",
  (nullable) => {
    test("absent roots, absent instructions, empty and sparse arrays", () => {
      expect(traverser(null, null, null, nullable)).toBe(nullable);
      expect(traverser(undefined, null, null, nullable)).toBe(nullable);
      expect(traverser({}, null, null, nullable)).toStrictEqual({});
      const values = [null, , undefined, 0, false, ""];
      const result = traverser({ values }, null, null, nullable);
      expect(result.values).toStrictEqual([nullable, , nullable, 0, false, ""]);
      expect(1 in result.values).toBe(false);
      expect(traverser([], {}, {}, nullable)).toStrictEqual([]);
    });

    test("frozen inputs, opaque Relay metadata and exact fragment snapshots", () => {
      const metadata = { value: null };
      metadata.cycle = metadata;
      const input = {
        value: null,
        nested: { value: null },
        __fragments: metadata,
        __fragmentOwner: metadata,
        __id: null,
        __typename: "User",
        __relay_internal__pv__flag: null,
      };
      // Freeze the cyclic metadata separately.
      Object.freeze(metadata);
      freeze(input);
      const result = traverser(
        input,
        { __root: { "": { f: "" }, nested: { f: "" } } },
        {},
        nullable,
      );
      expect(result.value).toBe(nullable);
      expect(result.__id).toBe(nullable);
      expect(result.__relay_internal__pv__flag).toBe(nullable);
      expect(result.__fragments).toBe(metadata);
      expect(result.__fragmentOwner).toBe(metadata);
      expect(result.fragmentRefs).toStrictEqual(input);
      expect(result.updatableFragmentRefs).toBe(result.fragmentRefs);
      expect(result.nested.fragmentRefs).toStrictEqual(input.nested);
      expect(result.nested.updatableFragmentRefs).toBe(
        result.nested.fragmentRefs,
      );
      expect(result.fragmentRefs).not.toHaveProperty("fragmentRefs");
      expect(input.value).toBeNull();
      expect(input.nested).toStrictEqual({ value: null });
    });

    test("enum arrays skip nulls and call converters once per non-null element", () => {
      const convert = jest.fn((v) => `converted:${v}`);
      const input = freeze({ items: ["A", null, "B"], sibling: "C" });
      const result = traverser(
        input,
        { __root: { items: { e: "enum" }, sibling: { e: "enum" } } },
        { enum: convert },
        nullable,
      );
      expect(result).toStrictEqual({
        items: ["converted:A", nullable, "converted:B"],
        sibling: "converted:C",
      });
      expect(convert.mock.calls).toEqual([["A"], ["B"], ["C"]]);
    });

    test("missing converters leave values available for nullable traversal", () => {
      const result = traverser(
        freeze({ item: { value: null }, items: [{ value: null }] }),
        { __root: { item: { c: "missing" }, items: { u: "missing" } } },
        {},
        nullable,
      );
      expect(result).toStrictEqual({
        item: { value: nullable },
        items: [{ value: nullable }],
      });
    });

    test("recursive input unions and arrays use their named instruction root", () => {
      const convert = jest.fn((v) => v.toLowerCase());
      const input = freeze({
        items: [{ __$inputUnion: "choice", _0: { status: "A" } }, null],
        tree: { status: "B", children: [{ status: "C", children: [] }] },
      });
      const result = traverser(
        input,
        {
          __root: { items: { r: "Input" }, tree: { r: "Tree" } },
          Input: { choice_status: { e: "enum" } },
          Tree: { status: { e: "enum" }, children: { r: "Tree" } },
        },
        { enum: convert },
        nullable,
      );
      expect(result).toStrictEqual({
        items: [{ choice: { status: "a" } }, nullable],
        tree: { status: "b", children: [{ status: "c", children: [] }] },
      });
      expect(convert.mock.calls).toEqual([["A"], ["B"], ["C"]]);
    });

    test("root union arrays dispatch each member independently", () => {
      const union = jest.fn((v) => v);
      const input = freeze([
        { __typename: "User", value: null },
        null,
        { __typename: "Page", value: null },
        { __typename: "User", value: "ok" },
      ]);
      const result = traverser(
        input,
        { __root: { "": { u: "union" }, User: { f: "" } } },
        { union },
        nullable,
      );
      expect(result[0].fragmentRefs).toStrictEqual(input[0]);
      expect(result[0].value).toBe(nullable);
      expect(result[1]).toBe(nullable);
      expect(result[2]).toStrictEqual({ __typename: "Page", value: nullable });
      expect(result[3].fragmentRefs).toStrictEqual(input[3]);
      expect(union).toHaveBeenCalledTimes(3);
    });

    test("custom scalar results remain opaque, including falsey values", () => {
      for (const output of [
        false,
        0,
        "",
        null,
        undefined,
        { value: null },
        [null],
      ]) {
        const convert = jest.fn(() => output);
        const result = traverser(
          freeze({ scalar: "input", after: null }),
          { __root: { scalar: { c: "scalar" } } },
          { scalar: convert },
          nullable,
        );
        expect(result.scalar).toBe(output);
        expect(result.after).toBe(nullable);
        expect(convert.mock.calls).toEqual([["input"]]);
      }
    });

    test("blocked JSON retains identity and nested nulls", () => {
      const json = freeze({ value: null, nested: [null] });
      const result = traverser(
        freeze({ json, items: [json, null], after: null }),
        { __root: { json: { b: "" }, items: { b: "a" } } },
        {},
        nullable,
      );
      expect(result.json).toBe(json);
      expect(result.items[0]).toBe(json);
      expect(result.items[1]).toBe(nullable);
      expect(result.after).toBe(nullable);
    });

    test("nested union conversion runs in the correct order in each direction", () => {
      const events = [];
      const union = (v) => {
        events.push("union");
        return { ...v, marker: true };
      };
      const scalar = (v) => {
        events.push("scalar");
        return v + 1;
      };
      const result = traverser(
        freeze({ item: { __typename: "User", value: 1 } }),
        { __root: { item: { u: "union" }, item_User_value: { c: "scalar" } } },
        { union, scalar },
        nullable,
      );
      expect(result).toStrictEqual({
        item: { __typename: "User", value: 2, marker: true },
      });
      expect(events).toStrictEqual(
        nullable === null ? ["union", "scalar"] : ["scalar", "union"],
      );
    });
  },
);

describe("conversion sharing and repeatability", () => {
  test("unchanged roots, objects, lists and nulls retain identity", () => {
    const root = freeze({
      id: "1",
      nested: { value: 3 },
      list: [{ value: 2 }, "x"],
      empty: [],
    });
    expect(traverser(root)).toBe(root);
    expect(traverser(root.list)).toBe(root.list);
    expect(traverser(root.empty)).toBe(root.empty);
    const nullable = freeze({ value: null, list: [null] });
    expect(traverser(nullable, {}, {}, null)).toBe(nullable);
  });

  test("copies only ancestors of changes and preserves untouched siblings", () => {
    const root = freeze({
      left: { value: 1 },
      right: { value: null },
      list: [{ value: 1 }, { value: null }],
    });
    const result = traverser(root);
    expect(result).not.toBe(root);
    expect(result.left).toBe(root.left);
    expect(result.right).not.toBe(root.right);
    expect(result.list).not.toBe(root.list);
    expect(result.list[0]).toBe(root.list[0]);
    expect(result.list[1]).not.toBe(root.list[1]);
  });

  test("does not cache mutable inputs, instructions or converter closures", () => {
    const root = { value: 1 };
    const maps = { __root: { value: { c: "scalar" } } };
    let offset = 1;
    const converters = { scalar: (v) => v + offset };
    expect(traverser(root, maps, converters).value).toBe(2);
    offset = 2;
    expect(traverser(root, maps, converters).value).toBe(3);
    root.value = 2;
    expect(traverser(root, maps, converters).value).toBe(4);
    maps.__root.value = {};
    expect(traverser(root, maps, converters).value).toBe(2);
  });

  test("mixed union lists convert untyped siblings independently", () => {
    const input = freeze({
      items: [{ __typename: "User", value: null }, { value: null }, null],
    });
    const result = traverser(
      input,
      { __root: { items: { u: "union" } } },
      { union: (v) => v },
    );
    expect(result).toStrictEqual({
      items: [
        { __typename: "User", value: undefined },
        { value: undefined },
        undefined,
      ],
    });
  });

  test("fragment refs in lists stay raw and share their updatable ref", () => {
    const input = freeze({ items: [{ value: null, nested: { value: null } }] });
    const result = traverser(input, { __root: { items: { f: "" } } });
    expect(result.items[0].fragmentRefs).toStrictEqual(input.items[0]);
    expect(result.items[0].fragmentRefs.nested).toBe(input.items[0].nested);
    expect(result.items[0].updatableFragmentRefs).toBe(
      result.items[0].fragmentRefs,
    );
    expect(result.items[0].nested.value).toBeUndefined();
  });

  test("fragment refs on opaque array elements do not traverse JSON", () => {
    const input = freeze({ items: [{ value: null }] });
    const result = traverser(input, { __root: { items: { f: "", b: "a" } } });
    expect(result.items[0].value).toBeNull();
    expect(result.items[0].fragmentRefs).toStrictEqual(input.items[0]);
  });

  test("sparse plural roots preserve holes", () => {
    const input = freeze([{ value: null }, , null]);
    expect(traverser(input)).toStrictEqual([{ value: undefined }, , undefined]);
  });

  test("converter exceptions propagate without mutating the input", () => {
    const input = freeze({ before: null, value: "bad" });
    const error = new Error("bad scalar");
    expect(() =>
      traverser(
        input,
        { __root: { value: { c: "scalar" } } },
        {
          scalar: () => {
            throw error;
          },
        },
      ),
    ).toThrow(error);
    expect(input.before).toBeNull();
  });

  test("deterministic generated trees match an independent nullable conversion model", () => {
    let seed = 0x12345678;
    const random = () => {
      seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
      return seed;
    };
    function generate(depth) {
      if (!depth)
        return [null, undefined, false, 0, "", "text", 42][random() % 7];
      return {
        value: generate(0),
        child: generate(depth - 1),
        items: Array.from({ length: random() % 5 }, () => generate(depth - 1)),
      };
    }
    function reference(value, nullable) {
      if (value == null) return nullable;
      if (Array.isArray(value)) return value.map((v) => reference(v, nullable));
      if (typeof value === "object")
        return Object.fromEntries(
          Object.entries(value).map(([k, v]) => [k, reference(v, nullable)]),
        );
      return value;
    }
    for (let i = 0; i < 100; i++) {
      const input = freeze(generate(3));
      for (const nullable of [null, undefined]) {
        expect(traverser(input, {}, {}, nullable)).toStrictEqual(
          reference(input, nullable),
        );
      }
    }
  });
});

test("generated combinations of enums, scalar lists, recursion and union members have exact outputs", () => {
  for (let size = 0; size < 25; size++) {
    const rows = Array.from({ length: size }, (_, i) => ({
      __typename: i % 2 ? "User" : "Page",
      status: i % 3 ? "ON" : null,
      scalar: String(i),
      json: { nullable: null },
    }));
    const input = freeze({ rows, after: null });
    for (const nullable of [undefined, null]) {
      let scalarCalls = 0;
      const converters = {
        union: (v) => v,
        enum: (v) => v.toLowerCase(),
        scalar: (v) => {
          scalarCalls++;
          return Number(v);
        },
      };
      const instructions = { rows: { u: "union" } };
      for (const member of ["User", "Page"]) {
        instructions[`rows_${member}_status`] = { e: "enum" };
        instructions[`rows_${member}_scalar`] = { c: "scalar" };
        instructions[`rows_${member}_json`] = { b: "" };
      }
      expect(
        traverser(input, { __root: instructions }, converters, nullable),
      ).toStrictEqual({
        rows: rows.map((row) => ({
          ...row,
          status: row.status === null ? nullable : "on",
          scalar: Number(row.scalar),
        })),
        after: nullable,
      });
      expect(scalarCalls).toBe(size);
    }
  }
});

test("recursive array roots are converted exactly once, including nullable scalar results", () => {
  const input = freeze({ items: [{ value: "wire" }], after: null });
  const output = { value: null };
  const scalar = jest.fn(() => output);
  const result = traverser(
    input,
    { __root: { items: { r: "Input" } }, Input: { value: { c: "scalar" } } },
    { scalar },
  );
  expect(result.items[0].value).toBe(output);
  expect(result.items[0].value.value).toBeNull();
  expect(result.after).toBeUndefined();
  expect(scalar).toHaveBeenCalledTimes(1);
});
