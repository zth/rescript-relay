require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_updatableQuery } = require("./Test_updatableQuery.bs");

describe("Updatable query", () => {
  test("updatable queries work", async () => {
    queryMock.mockQuery({
      name: "TestUpdatableQuery",
      variables: {
        id: "user-1",
      },
      data: {
        user: {
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

    t.render(test_updatableQuery());
    await t.screen.findByText("First is offline and best friends with Isaac");
    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Change status"));
    });
    await t.screen.findByText("Mrmr is online and best friends with Newton");
  });
});
