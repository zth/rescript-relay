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

describe("codegen", ({test, _}) => {
  test("print enums formatted", ({expect, _}) => {
    Types.(
      Printer.(
        expect.string(
          printEnumDefinition({
            name: "someEnum",
            values: ["First", "Second", "Third"],
          }),
        ).
          toMatchSnapshot()
      )
    )
  });

  test("prints string literal, unescaped", ({expect, _}) => {
    Printer.(
      expect.string(
        printStringLiteral(
          ~literal="some_valid_literal",
          ~needsEscaping=false,
        ),
      ).
        toMatchSnapshot()
    )
  });

  test("prints string literal, escaped", ({expect, _}) => {
    Printer.(
      expect.string(
        printStringLiteral(
          ~literal="some invalid string literal",
          ~needsEscaping=true,
        ),
      ).
        toMatchSnapshot()
    )
  });

  let make_mock_full_state = (): Types.fullState => {
    enums: [],
    unions: [],
    objects: [],
    variables: None,
    response: None,
    rawResponse: None,
    fragment: None,
  };

  test("prints record structure", ({expect, _}) => {
    Printer.(
      expect.string(
        printObject(
          ~obj={
            comment: None,
            values: [
              Prop(
                "someProp",
                {comment: None, nullable: true, propType: DataId},
              ),
              Prop(
                "anotherProp",
                {comment: None, nullable: false, propType: Scalar(Int)},
              ),
              Prop(
                "aThirdProp",
                {
                  comment: None,
                  nullable: true,
                  propType:
                    Array({
                      comment: None,
                      nullable: true,
                      propType: TypeReference("some_type"),
                    }),
                },
              ),
            ],
            atPath: [],
          },
          ~ignoreFragmentRefs=false,
          ~state=make_mock_full_state(),
          (),
        ),
      ).
        toMatchSnapshot()
    )
  });
});
