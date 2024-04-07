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
          bestFriend: {
            __typename: "User",
            id: "user-2",
            firstName: "Isaac",
          },
        },
      },
    });

    t.render(test_updatableFragments());
    await t.screen.findByText("First is offline and best friends with Isaac");
    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Change status"));
    });
    await t.screen.findByText("Mrmr is online and best friends with Newton");
  });
});
