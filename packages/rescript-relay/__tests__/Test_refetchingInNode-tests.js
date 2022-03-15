require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_refetching } = require("./Test_refetchingInNode.bs");

describe("Fragment", () => {
  test("refetching in node works", async () => {
    queryMock.mockQuery({
      name: "TestRefetchingInNodeQuery",
      variables: {
        userId: "user-1",
        friendsOnlineStatuses: ["Online"],
      },
      data: {
        node: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          onlineStatus: null,
          friendsConnection: {
            totalCount: 10,
          },
        },
      },
    });

    t.render(test_refetching());

    await t.screen.findByText("First is -");
    await t.screen.findByText("Friends: 10");

    queryMock.mockQuery({
      name: "TestRefetchingInNodeRefetchQuery",
      variables: {
        id: "user-1",
        showOnlineStatus: true,
        friendsOnlineStatuses: null,
      },
      data: {
        node: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          onlineStatus: "Online",
          friendsConnection: {
            totalCount: 20,
          },
        },
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Fetch online status"));
    });

    await t.screen.findByText("First is online");
    await t.screen.findByText("Friends: 20");
  });
});
