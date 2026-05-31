require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const {
  test_nullableScalarsAfterCustomScalarArray,
} = require("./Test_nullableScalarsAfterCustomScalarArray.bs");

// Nullable scalars selected after a `[CustomScalar!]` field whose runtime value
// is a non-null array must still decode to `None` when the wire data is `null`.
//
// The custom-scalar-array branch in `traverse` (utils.js) is the conversion path
// for fields like `intStrings: [IntString!]`. When that branch fires, every
// subsequent field in the same record's selection set goes through the rest of
// the per-key loop body. Their `null` values must therefore reach the
// null-coercion that turns `null` into the configured nullable representation
// (`undefined` for fragments). If that coercion is skipped, ReScript reads the
// raw `null` as `Some(null)` and pattern matches take the wrong branch.
describe("Nullable scalars following a custom-scalar array", () => {
  test("nullable scalars selected after a [CustomScalar!] field decode to None when null", async () => {
    queryMock.mockQuery({
      name: "TestNullableScalarsAfterCustomScalarArrayQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          intStrings: ["1", "2"],
          avatarUrl: null,
          isOnline: null,
          private: null,
          onlineStatus: null,
        },
      },
    });

    t.render(test_nullableScalarsAfterCustomScalarArray());

    // The `private` label runs `Type.classify` (via Obj.magic + Null.toOption)
    // on the option's payload, so when the bug fires the rendered text is
    // literally `private=Some(null)` — the smoking gun. The fixed behaviour
    // is `private=None`.
    await t.screen.findByText("avatarUrl=None");
    await t.screen.findByText("isOnline=None");
    await t.screen.findByText("private=None");
    await t.screen.findByText("onlineStatus=None");
  });
});
