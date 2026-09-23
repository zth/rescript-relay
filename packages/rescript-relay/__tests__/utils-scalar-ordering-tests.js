const { traverser, prepareConversion } = require("../src/utils");
const { freeze } = require("./helpers/conversionModel");

function permutations(values) {
  if (values.length === 0) return [[]];
  return values.flatMap((value, index) =>
    permutations(values.filter((_, i) => i !== index)).map(rest => [value, ...rest]),
  );
}
const fields = ["single", "many", "nested", "nullable", "last"];
const orders = permutations(fields);
const entries = [
  { path: ["single"], scalar: "single" },
  { path: ["many"], list: 1, scalar: "many" },
  { path: ["nested"], reference: "Input" },
  { path: ["last"], scalar: "last" },
];
const legacyEntries = [
  ["single", { c: "single" }],
  ["many", { ca: "many" }],
  ["nested", { r: "Input" }],
  ["last", { c: "last" }],
];

describe.each(["legacy", "prepared"])("%s custom scalar ordering", runtime => {
  test.each([undefined, null])("all 120 sibling orders and both instruction orders (nullable=%s)", nullable => {
    for (const reversePlan of [false, true]) {
      for (const order of orders) {
        const source = {
          single: [1], // One array-backed scalar, not a GraphQL list.
          many: [[2], null, , [3]], // A sparse GraphQL list of array-backed scalars.
          nested: { value: [4], after: null },
          nullable: null,
          last: [5],
        };
        const input = freeze(Object.fromEntries(order.map(key => [key, source[key]])));
        const trace = [];
        const outputs = {};
        const callbacks = Object.fromEntries(["single", "many", "nested", "last"].map(name => [
          name,
          value => {
            trace.push([name, value]);
            // Returning arrays/objects with nulls catches accidental traversal
            // of parser/serializer results, including repeated conversion.
            const result = freeze({ converted: value[0], untouched: [null] });
            outputs[value[0]] = result;
            return result;
          },
        ]));
        const ordered = values => reversePlan ? values.slice().reverse() : values;
        const convert = runtime === "prepared"
          ? prepareConversion({ version: 2, roots: {
              __root: ordered(entries),
              Input: [{ path: ["value"], scalar: "nested" }],
            } }, callbacks, nullable)
          : value => traverser(value, {
              __root: Object.fromEntries(ordered(legacyEntries)),
              Input: { value: { c: "nested" } },
            }, callbacks, nullable);
        const expectedTrace = order.flatMap(key => ({
          single: [["single", source.single]],
          many: [["many", source.many[0]], ["many", source.many[3]]],
          nested: [["nested", source.nested.value]],
          nullable: [],
          last: [["last", source.last]],
        })[key]);
        for (let call = 0; call < 2; call++) {
          trace.length = 0;
          const result = convert(input);
          expect(trace).toStrictEqual(expectedTrace);
          expect(result).toStrictEqual({
            single: outputs[1],
            many: [outputs[2], nullable, , outputs[3]],
            nested: { value: outputs[4], after: nullable },
            nullable,
            last: outputs[5],
          });
          expect(result.single).toBe(outputs[1]);
          expect(result.many[0]).toBe(outputs[2]);
          expect(Object.keys(result)).toEqual(order);
        }
        expect(input.single).toBe(source.single);
        expect(input.nested.after).toBeNull();
        expect(input.nullable).toBeNull();
      }
    }
  });
  test.each([undefined, null])("empty scalar arrays differ from empty GraphQL lists (nullable=%s)", nullable => {
    const single = [];
    const element = [];
    const callback = jest.fn(value => ({ raw: value }));
    const input = freeze({ single, emptyList: [], list: [element, null], after: null });
    const convert = runtime === "prepared"
      ? prepareConversion({ version: 2, roots: { __root: [
          { path: ["single"], scalar: "scalar" },
          { path: ["emptyList"], list: 1, scalar: "scalar" },
          { path: ["list"], list: 1, scalar: "scalar" },
        ] } }, { scalar: callback }, nullable)
      : value => traverser(value, { __root: {
          single: { c: "scalar" }, emptyList: { ca: "scalar" }, list: { ca: "scalar" },
        } }, { scalar: callback }, nullable);
    const result = convert(input);
    expect(callback).toHaveBeenCalledTimes(2);
    expect(callback.mock.calls[0][0]).toBe(single);
    expect(callback.mock.calls[1][0]).toBe(element);
    expect(result.single.raw).toBe(single);
    expect(result.emptyList).toEqual([]);
    expect(result.list[0].raw).toBe(element);
    expect(result.list[1]).toBe(nullable);
    expect(result.after).toBe(nullable);
  });

});

describe.each([undefined, null])("prepared scalar result boundary (nullable=%s)", nullable => {
  test("all scalar results remain opaque at root, field and list positions", () => {
    const results = [false, 0, "", null, undefined, [null], { value: null },
      { BS_PRIVATE_NESTED_SOME_NONE: 0 }, new Date("2020-01-01")];
    for (const returned of results) {
      for (const position of ["root", "field", "list"]) {
        const callback = jest.fn(() => returned);
        const convert = prepareConversion({ version: 2, roots: { __root: [
          { path: position === "root" ? [] : ["value"], scalar: "scalar",
            ...(position === "list" ? { list: 1 } : {}) },
        ] } }, { scalar: callback }, nullable);
        const result = convert(freeze(position === "root" ? "wire" : {
          value: position === "list" ? ["wire", null] : "wire", after: null,
        }));
        expect(position === "root" ? result : position === "list" ? result.value[0] : result.value).toBe(returned);
        expect(callback).toHaveBeenCalledTimes(1);
        expect(callback).toHaveBeenCalledWith("wire");
        if (position !== "root") expect(result.after).toBe(nullable);
        if (position === "list") expect(result.value[1]).toBe(nullable);
      }
    }
  });

  test("list callback errors stop later elements and siblings, and do not poison subsequent calls", () => {
    const failure = new Error("scalar failed");
    const trace = [];
    const convert = prepareConversion({ version: 2, roots: { __root: [
      { path: ["values"], list: 1, scalar: "scalar" },
      { path: ["after"], scalar: "scalar" },
    ] } }, { scalar: value => {
      trace.push(value);
      if (value === "bad") throw failure;
      return [value];
    } }, nullable);
    const input = freeze({ values: ["first", "bad", "last"], after: "sibling" });
    expect(() => convert(input)).toThrow(failure);
    expect(trace).toEqual(["first", "bad"]);
    expect(input).toStrictEqual({ values: ["first", "bad", "last"], after: "sibling" });
    trace.length = 0;
    expect(convert(freeze({ values: ["good"], after: "sibling" }))).toStrictEqual({ values: [["good"]], after: ["sibling"] });
    expect(trace).toEqual(["good", "sibling"]);
  });
});
