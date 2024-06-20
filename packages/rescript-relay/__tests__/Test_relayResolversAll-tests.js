require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_relayResolversAll } = require("./Test_relayResolversAll.bs");

describe("Relay Resolvers all", () => {
  test("basic Relay Resolvers work", async () => {
    queryMock.mockQuery({
      name: "TestRelayResolversAllQuery",
      data: {},
    });

    t.render(test_relayResolversAll());
    await t.screen.findByText("Test User is online");
  });
});
