require("@testing-library/jest-dom/extend-expect");
const queryMock = require("./queryMock");

const { test_requiredFieldLogger, getLoggedValue, expectedValue } = require("./Test_requiredFieldLogger.bs");

describe("RequiredFieldLogger", () => {
    test("logs missing field", async () => {
      queryMock.mockQuery({
        name: "TestRequiredFieldLoggerQuery",
        data: {
          loggedInUser: {
            id: "user-123",
            firstName: null,
          },
          users: null,
        },
      });

      await test_requiredFieldLogger()

      expect(getLoggedValue()).toBe(expectedValue)

    });
  });
