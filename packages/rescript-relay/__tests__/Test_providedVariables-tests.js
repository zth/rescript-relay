require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_providedVariables } = require("./Test_providedVariables.bs");

describe("Provided variables", () => {
  test("provided variables work", async () => {
    queryMock.mockQuery({
      name: "TestProvidedVariablesQuery",
      variables: {
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
      },
      data: {
        loggedInUser: {
          __typename: "User",
          id: "user-1",
          someRandomArgField: "hello",
        },
      },
    });

    t.render(test_providedVariables());
    await t.screen.findByText("hello");
  });
});
