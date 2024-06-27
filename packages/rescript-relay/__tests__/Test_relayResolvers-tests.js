require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_relayResolvers } = require("./Test_relayResolvers.bs");

describe("Relay Resolvers", () => {
  test("basic Relay Resolvers work", async () => {
    queryMock.mockQuery({
      name: "TestRelayResolversQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          isOnline: true,
        },
      },
    });

    t.render(test_relayResolvers());
    await t.screen.findByText("First Last Fi is online");
  });
});
