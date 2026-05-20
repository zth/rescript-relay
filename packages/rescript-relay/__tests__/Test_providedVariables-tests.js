require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_providedVariables } = require("./Test_providedVariables.bs");

describe("Provided variables", () => {
  const providedVariables = {
    __relay_internal__pv__ProvidedVariablesBool: true,
    __relay_internal__pv__ProvidedVariablesInputC: {
      intStr: "123",
      recursiveC: {
        intStr: "234",
      },
    },
    __relay_internal__pv__ProvidedVariablesInputCArr: [
      {
        intStr: "123",
      },
    ],
    __relay_internal__pv__ProvidedVariablesIntStr: "456",
    __relay_internal__pv__ProvidedVariablesIntStrArr: ["456"],
  };

  const mockProvidedVariablesQuery = (someRandomArgField) =>
    queryMock.mockQuery({
      name: "TestProvidedVariablesQuery",
      variables: providedVariables,
      data: {
        loggedInUser: {
          __typename: "User",
          id: "user-1",
          someRandomArgField,
        },
      },
    });

  test("provided variables work", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");
  });

  test("loading a no-variable query with provided variables from the raw module works", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test provided variable raw load"));
    });

    await t.screen.findByText("Preloaded provided variable: hello");
  });

  test("loading a no-variable query with provided variables through useLoader works", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");

    ReactTestUtils.act(() => {
      t.fireEvent.click(
        t.screen.getByText("Test provided variable query loader")
      );
    });

    await t.screen.findByText("Preloaded provided variable: hello");
  });

  test("fetching a no-variable query with provided variables works", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");

    mockProvidedVariablesQuery("fetch");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test provided variable fetch"));
    });

    await t.screen.findByText("Provided variable fetch status: fetch");
  });

  test("fetching a no-variable query with provided variables as a promise works", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");

    mockProvidedVariablesQuery("fetch promised");

    ReactTestUtils.act(() => {
      t.fireEvent.click(
        t.screen.getByText("Test provided variable fetch promised")
      );
    });

    await t.screen.findByText("Provided variable fetch status: fetch promised");
  });

  test("retaining a no-variable query with provided variables works", async () => {
    mockProvidedVariablesQuery("hello");

    t.render(test_providedVariables());
    await t.screen.findByText("hello");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test provided variable retain"));
    });

    await t.screen.findByText("Provided variable retain status: retained");
  });
});
