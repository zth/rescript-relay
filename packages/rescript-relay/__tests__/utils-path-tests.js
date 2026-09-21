const { traverser } = require("../src/utils");

describe("conversion instruction paths", () => {
  test("handles nested underscore paths, nullability, enums, scalars, arrays, and fragments without mutating input", () => {
    const input = {
      account_details: {
        status_level: "2",
        optional_label: null,
        scores: ["3", null],
        profile_data: {
          created_at: "4",
        },
      },
    };
    const originalInput = JSON.parse(JSON.stringify(input));

    const result = traverser(
      input,
      {
        __root: {
          "": { f: "" },
          account_details: { f: "" },
          account_details_status_level: { e: "Status" },
          account_details_optional_label: { n: "" },
          account_details_scores: { n: "", e: "Status" },
          account_details_profile_data: { f: "" },
          account_details_profile_data_created_at: { c: "Int" },
        },
      },
      {
        Status: (value) => Number(value),
        Int: (value) => Number(value),
      },
      undefined
    );

    expect(result).toEqual({
      fragmentRefs: expect.any(Object),
      updatableFragmentRefs: expect.any(Object),
      account_details: {
        fragmentRefs: expect.any(Object),
        updatableFragmentRefs: expect.any(Object),
        status_level: 2,
        optional_label: undefined,
        scores: [3, undefined],
        profile_data: {
          fragmentRefs: expect.any(Object),
          updatableFragmentRefs: expect.any(Object),
          created_at: 4,
        },
      },
    });
    expect(input).toEqual(originalInput);
  });

  test("handles nested unions and root unions for objects and arrays", () => {
    const converters = {
      Node: (value) => ({ kind: value.__typename, value }),
      Status: (value) => Number(value),
    };
    const nestedInput = {
      nodes: [
        null,
        { __typename: "User", status_code: "5" },
        { __typename: "Team", status_code: "6" },
      ],
    };
    const nestedOriginal = JSON.parse(JSON.stringify(nestedInput));
    const instructions = {
      __root: {
        nodes: { n: "", u: "Node" },
        nodes_User: { f: "" },
        nodes_User_status_code: { e: "Status" },
        nodes_Team_status_code: { e: "Status" },
      },
    };

    expect(
      traverser(
        nestedInput,
        instructions,
        converters,
        undefined
      )
    ).toEqual({
      nodes: [
        undefined,
        {
          kind: "User",
          value: {
            fragmentRefs: expect.any(Object),
            updatableFragmentRefs: expect.any(Object),
            __typename: "User",
            status_code: 5,
          },
        },
        {
          kind: "Team",
          value: { __typename: "Team", status_code: 6 },
        },
      ],
    });
    expect(nestedInput).toEqual(nestedOriginal);

    const rootInstructions = {
      __root: {
        "": { u: "Node" },
        User: { f: "" },
        User_status_code: { e: "Status" },
      },
    };
    const user = { __typename: "User", status_code: "7" };

    expect(
      traverser(user, rootInstructions, converters, undefined)
    ).toEqual({
      kind: "User",
      value: {
        fragmentRefs: expect.any(Object),
        updatableFragmentRefs: expect.any(Object),
        __typename: "User",
        status_code: 7,
      },
    });
    expect(
      traverser([user, null], rootInstructions, converters, undefined)
    ).toEqual([
      {
        kind: "User",
        value: {
          fragmentRefs: expect.any(Object),
          updatableFragmentRefs: expect.any(Object),
          __typename: "User",
          status_code: 7,
        },
      },
      undefined,
    ]);
    expect(user).toEqual({ __typename: "User", status_code: "7" });
  });

  test("uses the selected root object instruction map", () => {
    const input = {
      filter_value: {
        minimum_score: "8",
        optional_score: null,
      },
    };

    expect(
      traverser(
        input,
        {
          Variables: { filter_value: { r: "FilterInput" } },
          FilterInput: {
            minimum_score: { c: "Int" },
            optional_score: { n: "" },
          },
        },
        { Int: (value) => Number(value) },
        undefined,
        "Variables"
      )
    ).toEqual({
      filter_value: { minimum_score: 8, optional_score: undefined },
    });
    expect(input).toEqual({
      filter_value: { minimum_score: "8", optional_score: null },
    });
  });
});
