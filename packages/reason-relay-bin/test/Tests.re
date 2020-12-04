open TestFramework;
open Lib;

describe("string literals", ({test, _}) => {
  test("identify valid string literals", ({expect, _}) => {
    open ParseFlowTypes;

    expect.bool(is_valid_literal_name("regular_identifier")).toBeTrue();
    expect.bool(is_valid_literal_name("_regular_identifier")).toBeTrue();
    expect.bool(is_valid_literal_name("regular identifier")).toBeFalse();
    expect.bool(is_valid_literal_name("regular-identifier")).toBeFalse();
    expect.bool(is_valid_literal_name("regular^!(identifier")).toBeFalse();
    expect.bool(is_valid_literal_name("Regular_identifier123")).toBeTrue();
    expect.bool(is_valid_literal_name("_regular_identifier123")).toBeTrue();
    expect.bool(is_valid_literal_name("123leading_number")).toBeFalse();
  })
});
