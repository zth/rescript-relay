require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const {
  test_customScalarAfterCustomScalarArray,
} = require("./Test_customScalarAfterCustomScalarArray.bs");

// Read-side analog of #582 / direct read-side analog of #631 (this PR):
// after a `[CustomScalar!]` field on the response is processed by the
// `ca` branch in `traverse` (utils.js), subsequent fields in the same
// selection set are leaked through `Object.assign` untouched. For a
// `c` custom scalar like `createdAt: Datetime!`, that means the user
// receives the raw wire string instead of a parsed `Date.t`.
//
// On master the rendered text never appears: `Date.getTime` on a raw
// string throws (no `.getTime` method on strings). On the fix, the
// timestamp renders.
describe("Custom scalar following a custom-scalar array (#582 read / #631)", () => {
  test("createdAt is parsed when intStrings precedes it in the selection set", async () => {
    const expected = new Date(2020, 1, 1, 0, 0, 0, 0);
    queryMock.mockQuery({
      name: "TestCustomScalarAfterCustomScalarArrayQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          intStrings: ["1", "2"],
          createdAt: expected.toJSON(),
        },
      },
    });

    t.render(test_customScalarAfterCustomScalarArray());

    await t.screen.findByText("createdAt: " + expected.getTime().toString());
  });
});
