require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const ReactTestUtils = require("react-dom/test-utils");
const queryMock = require("./queryMock");

const { test_subscription } = require("./Test_subscription.bs");

describe("Subscription", () => {
  test("basic subscriptions work", async () => {
    queryMock.mockQuery({
      name: "TestSubscriptionQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          avatarUrl: null,
          onlineStatus: "Online",
        },
      },
    });

    const testAssets = test_subscription();

    t.render(testAssets.render());

    await t.screen.findByText("Ready - User First is online");

    ReactTestUtils.act(() => {
      testAssets.pushNext({
        data: {
          userUpdated: {
            user: {
              id: "user-1",
              firstName: "First",
              avatarUrl: "http://some/avatar.png",
              onlineStatus: "Online",
            },
          },
        },
      });
    });

    await t.screen.findByAltText("avatar");
  });

  test("updater conversion works", async () => {
    queryMock.mockQuery({
      name: "TestSubscriptionQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          avatarUrl: null,
          onlineStatus: "Online",
        },
      },
    });

    const testAssets = test_subscription();

    t.render(testAssets.render());
    await t.screen.findByText("Ready - User First is online");

    ReactTestUtils.act(() => {
      testAssets.pushNext({
        data: {
          userUpdated: {
            user: {
              id: "user-1",
              firstName: "First",
              avatarUrl: null,
              onlineStatus: "Idle",
            },
          },
        },
      });
    });

    await t.screen.findByText("Ready - User First is offline");
  });
});
