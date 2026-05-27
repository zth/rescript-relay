require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const ReactTestUtils = require("react-dom/test-utils");
const TestFragmentRef = require("../src/RescriptRelay_TestFragmentRef.bs");
const PluralFragmentArtifact = require("./__generated__/TestTestingHelpers_plural_user_graphql.bs");

const {
  synthetic,
  syntheticOpt,
  syntheticPlural,
  syntheticEmptyPlural,
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

  test("empty synthetic plural fragment refs render without a Relay provider", () => {
    const { container } = t.render(syntheticEmptyPlural());
    expect(container.firstChild).toBeEmptyDOMElement();
  });

  test("empty real plural fragment ref arrays are not treated as synthetic", () => {
    expect(TestFragmentRef.getDataForNode(PluralFragmentArtifact.node, [])).toBeUndefined();
  });

  test("copied non-empty synthetic plural fragment ref arrays remain synthetic", () => {
    const users = [
      { id: "synthetic-user-4", firstName: "Copied Synthetic", onlineStatus: "Online" },
    ];
    const copiedRef = TestFragmentRef.makePlural(
      "TestTestingHelpers_plural_user",
      users
    ).slice();

    expect(TestFragmentRef.getDataForNode(PluralFragmentArtifact.node, copiedRef)).toEqual(
      users
    );
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
