const {
  internal_removeUndefinedAndConvertNullsRaw,
} = require("../src/RescriptRelay_Internal.bs");

describe("internal_removeUndefinedAndConvertNullsRaw", () => {
  it("keeps empty arrays while converting Some(None) to null", () => {
    const input = {
      after: { BS_PRIVATE_NESTED_SOME_NONE: 0 },
      forSaleStatuses: [],
      nullArray: [null],
      first: 12,
      omitted: undefined,
    };

    expect(internal_removeUndefinedAndConvertNullsRaw(input)).toEqual({
      after: null,
      forSaleStatuses: [],
      nullArray: [null],
      first: 12,
    });
  });

  it("drops None values and preserves non-null data", () => {
    const input = {
      noneValue: undefined,
      zero: 0,
      empty: "",
      nope: false,
      obj: { bar: 1 },
    };

    expect(internal_removeUndefinedAndConvertNullsRaw(input)).toEqual({
      zero: 0,
      empty: "",
      nope: false,
      obj: { bar: 1 },
    });
  });

});
