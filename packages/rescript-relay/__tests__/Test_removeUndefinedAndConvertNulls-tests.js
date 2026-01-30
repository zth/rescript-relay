const {
  internal_removeUndefinedAndConvertNullsRaw,
} = require("../src/RescriptRelay_Internal.bs");

describe("internal_removeUndefinedAndConvertNullsRaw", () => {
  it("keeps empty arrays while converting Some(None) to null", () => {
    const input = {
      after: { BS_PRIVATE_NESTED_SOME_NONE: 0 },
      forSaleStatuses: [],
      first: 12,
      omitted: undefined,
    };

    expect(internal_removeUndefinedAndConvertNullsRaw(input)).toEqual({
      after: null,
      forSaleStatuses: [],
      first: 12,
    });
  });
});
