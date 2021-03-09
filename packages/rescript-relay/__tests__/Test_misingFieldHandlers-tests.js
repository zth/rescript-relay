require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_missingFieldHandlers } = require("./Test_missingFieldHandlers.bs");
const { fireEvent } = require("@testing-library/react");

describe("Missing field handlers", () => {
  test("resolves nodes via top level node field from cache automatically", async () => {
    queryMock.mockQuery({
      name: "TestMissingFieldHandlersMeQuery",
      data: {
        loggedInUser: {
          firstName: "First",
          id: "123",
        },
      },
    });

    t.render(test_missingFieldHandlers());
    await t.screen.findByText("1: First");
    fireEvent.click(t.screen.getByText("Show next"));
    await t.screen.findByText("2: First");
  });
});
