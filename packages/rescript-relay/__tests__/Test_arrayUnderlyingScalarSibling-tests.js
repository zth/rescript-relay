require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const {
  test_arrayUnderlyingScalarSibling,
} = require("./Test_arrayUnderlyingScalarSibling.bs");

// Integration repro for issue #407: when a custom scalar's runtime
// representation is itself an array (here `Number = array<int>`), the
// `c` branch in `traverse` (utils.js:134-138) is what fires — not `ca`.
// That branch was added by PR #434 to close #407 but it terminated with
// `return` instead of `continue`, so any sibling variable processed
// after the array-backed scalar had its converter skipped. This test
// declares `$number: Number!` before `$beforeDate: Datetime`, which
// puts `number` first in the generated variables record and thus first
// in the per-key iteration. With the bug, only `Number.serialize` would
// run; with the fix in this PR, both `Number.serialize` and
// `Datetime.serialize` run.
describe("Array-backed custom scalar followed by another custom scalar (#407)", () => {
  test("sibling Datetime variable is still serialized after array-backed Number", async () => {
    const logSpy = jest.spyOn(console, "log");
    queryMock.mockQuery({
      name: "TestArrayUnderlyingScalarSiblingQuery",
      variables: {
        aaNumber: 6,
        beforeDate: "1970-01-01T00:00:00.000Z",
      },
      data: {
        loggedInUser: {
          id: "user-1",
          friends: [],
        },
      },
    });

    t.render(test_arrayUnderlyingScalarSibling());

    await t.screen.findByText("rendered");

    expect(logSpy).toHaveBeenCalledWith("Number.serialize");
    expect(logSpy).toHaveBeenCalledWith("Datetime.serialize");
  });
});
