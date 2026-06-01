require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const {
  test_serializeMultipleCustomScalars,
} = require("./Test_serializeMultipleCustomScalars.bs");

// Integration repro for issue #582 (ValdemarGr): adding a `[CustomScalar]`
// field next to another `CustomScalar` field in an input object causes the
// second scalar's serializer to be skipped — the wire receives the raw
// ReScript value instead of the serialized form. Same root cause as the
// bug in this PR (#631): the custom-scalar-array branch in
// `traverse` (utils.js) exits the per-key loop with `return` instead of
// `continue`, so every subsequent field is leaked through
// `Object.assign` untouched.
//
// On master both serializers' log lines should NOT both fire — only
// `ObjectScalar1.serialize` runs (the one in the `os1s` array) and
// `ObjectScalar2.serialize` is skipped. With the fix in this PR, both
// run.
describe("Serialize multiple custom scalars (#582)", () => {
  test("ca followed by c in input — both serializers run", async () => {
    const logSpy = jest.spyOn(console, "log");
    t.render(test_serializeMultipleCustomScalars());

    const resolveQuery = queryMock.mockQueryWithControlledResolution({
      name: "TestSerializeMultipleCustomScalarsMutation",
      data: {
        serializeMultipleCustomScalars: true,
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Fire mutation"));
    });

    await t.screen.findByText("Mutating...");

    ReactTestUtils.act(() => {
      resolveQuery();
    });

    expect(logSpy).toHaveBeenCalledWith("ObjectScalar1.serialize");
    expect(logSpy).toHaveBeenCalledWith("ObjectScalar2.serialize");
  });
});
