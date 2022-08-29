require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_connections } = require("./Test_connections.bs");

describe("Connections", () => {
  test("basic fragments work", async () => {
    queryMock.mockQuery({
      name: "TestConnectionsQuery",
      matchVariables: (_) => true,
      data: {
        loggedInUser: {
          __typename: "User",
          id: "user-1",
          friendsConnection: {
            pageInfo: {
              endCursor: null,
              startCursor: null,
              hasNextPage: false,
              hasPreviousPage: false,
            },
            edges: [
              { cursor: "user-2", node: { id: "user-2", __typename: "User" } },
            ],
          },
        },
      },
    });

    t.render(test_connections());
    await t.screen.findByText("user-2");

    queryMock.mockQuery({
      name: "TestConnections_AddFriendMutation",
      matchVariables: (_) => true,
      data: {
        addFriend: {
          addedFriend: {
            __typename: "User",
            id: "user-3",
          },
        },
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Add friend"));
    });

    await t.screen.findByText("user-3");
  });
});
