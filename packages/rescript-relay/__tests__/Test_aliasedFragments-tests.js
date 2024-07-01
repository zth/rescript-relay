require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_aliasedFragments } = require("./Test_aliasedFragments.bs");

describe("Aliased fragments", () => {
  test("basic fragments work", async () => {
    queryMock.mockQuery({
      name: "TestAliasedFragmentsQuery",
      variables: {
        skipThing: false,
      },
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
        },
      },
    });

    t.render(test_aliasedFragments());
    await t.screen.findByText("First Last");
  });
});
