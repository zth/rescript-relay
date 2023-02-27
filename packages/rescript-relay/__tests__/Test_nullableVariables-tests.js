require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_nullableVariables } = require("./Test_nullableVariables.bs");

describe("Mutation", () => {
  test("variables can be null", async () => {
    queryMock.mockQuery({
      name: "TestNullableVariablesQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          avatarUrl: "avatar-url-1",
        },
      },
    });

    t.render(test_nullableVariables());
    await t.screen.findByText("Avatar url is avatar-url-1");

    queryMock.mockQuery({
      name: "TestNullableVariablesMutation",
      matchVariables: (v) => {
        console.log(v);
        return false;
      },
      variables: {
        avatarUrl: null,
        someInput: {
          int: null,
        },
      },
      data: {
        updateUserAvatar: {
          user: {
            id: "user-1",
            avatarUrl: null,
            someRandomArgField: "test",
          },
        },
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Change avatar URL"));
    });

    await t.screen.findByText("Avatar url is -");
  });
});
