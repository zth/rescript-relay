require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_updatableFragments } = require("./Test_updatableFragments.bs");

describe("Updatable fragments", () => {
  test("updatable fragments work", async () => {
    queryMock.mockQuery({
      name: "TestUpdatableFragmentsQuery",
      data: {
        loggedInUser: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          isOnline: false,
        },
      },
    });

    t.render(test_updatableFragments());
    await t.screen.findByText("First is offline");
    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Change status"));
    });
    await t.screen.findByText("Mrmr is online");
  });
});
