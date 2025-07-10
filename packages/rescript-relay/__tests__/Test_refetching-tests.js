require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_refetching } = require("./Test_refetching.bs");

describe("Fragment", () => {
  test("refetching works", async () => {
    queryMock.mockQuery({
      name: "TestRefetchingQuery",
      variables: { beforeDate: "2023-01-01T00:00:00.000Z" },
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          onlineStatus: null,
          friendsConnection: {
            totalCount: 20,
          },
          friends: [
            {
              id: "user-2",
            },
          ],
        },
      },
    });

    t.render(test_refetching());

    await t.screen.findByText("First is -");
    await t.screen.findByText("Friends: 20");

    queryMock.mockQuery({
      name: "TestRefetchingRefetchQuery",
      variables: {
        id: "user-1",
        showOnlineStatus: true,
        friendsOnlineStatuses: ["Online", "offline"],
        beforeDate: null,
      },
      data: {
        node: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          onlineStatus: "Online",
          friendsConnection: {
            totalCount: 10,
          },
          friends: [
            {
              id: "user-2",
            },
            {
              id: "user-3",
            },
          ],
        },
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Fetch online status"));
    });

    await t.screen.findByText("First is online");
    await t.screen.findByText("Friends: 10");
  });
});
