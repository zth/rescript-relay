require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const queryMock = require("./queryMock");

const { test_missingFieldHandlers } = require("./Test_missingFieldHandlersLinked.bs");
const { fireEvent } = require("@testing-library/react");
const ReactTestUtils = require("react-dom/test-utils");

describe("Missing linked field handlers", () => {
  test("resolves nodes via top level node field from cache automatically", async () => {
    queryMock.mockQuery({
      name: "TestMissingFieldHandlersLinkedMeQuery",
      data: {
        loggedInUser: {
          firstName: "First",
          id: "123",
        },
      },
    });

    t.render(test_missingFieldHandlers());
    await t.screen.findByText("1: First");

    ReactTestUtils.act(() => {
      fireEvent.click(t.screen.getByText("Show next"));
    });
    await t.screen.findByText("2: First");
  });
});
