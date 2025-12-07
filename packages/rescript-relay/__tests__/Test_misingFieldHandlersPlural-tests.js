require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const queryMock = require("./queryMock");

const { test_missingFieldHandlers } = require("./Test_missingFieldHandlersPlural.bs");
const { fireEvent } = require("@testing-library/react");
const ReactTestUtils = require("react-dom/test-utils");

describe("Missing plural linked field handlers for user", () => {
  test("resolves a plural linked record field via an equivalent field from cache automatically", async () => {
    queryMock.mockQuery({
      name: "TestMissingFieldHandlersPluralQuery",
      data: {
        topOnlineUserList: [
          {
            firstName: "Björn",
            id: "123",
          },
          {
            firstName: "Sven",
            id: "456",
          },
      ]
      },
    });

    t.render(test_missingFieldHandlers());
    await t.screen.findByText("1: Björn - Sven");

    ReactTestUtils.act(() => {
      fireEvent.click(t.screen.getByText("Show next"));
    });
    await t.screen.findByText("2: Björn - Sven");
  });
});
