require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const ReactTestUtils = require("react-dom/test-utils");

const {
  synthetic,
  syntheticOpt,
  syntheticPlural,
  environment,
  queryHelpers,
  interleaved,
  resolveQueryHelpers,
} = require("./Test_testingHelpers.bs");

describe("Testing helpers", () => {
  test("synthetic fragment refs render without a Relay provider", async () => {
    t.render(synthetic());
    await t.screen.findByText("Synthetic User");
  });

  test("synthetic fragment refs work with useOpt", async () => {
    t.render(syntheticOpt());
    await t.screen.findByText("Synthetic via opt");
  });

  test("synthetic plural fragment refs render without a Relay provider", async () => {
    t.render(syntheticPlural());
    await t.screen.findByText("Plural Synthetic is online");
  });

  test("typed query test helpers resolve a mock environment operation", async () => {
    const relayEnvironment = environment();
    t.render(queryHelpers(relayEnvironment));

    ReactTestUtils.act(() => {
      resolveQueryHelpers(relayEnvironment);
    });

    await t.screen.findByText("Typed from query helper");
  });

  test("synthetic and real fragment refs can be rendered side by side", async () => {
    const relayEnvironment = environment();
    t.render(interleaved(relayEnvironment));

    ReactTestUtils.act(() => {
      resolveQueryHelpers(relayEnvironment);
    });

    await t.screen.findByText("Interleaved Synthetic User");
    await t.screen.findByText("Typed Real");
  });
});
