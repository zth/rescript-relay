require("@testing-library/jest-dom/extend-expect");
const queryMock = require("./queryMock");

const { test_nonReact } = require("./Test_nonReact.bs");

describe("Fragment", () => {
  test("waitForFragmentData works", async () => {
    queryMock.mockQuery({
      name: "TestNonReactQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          onlineStatus: "Online",
        },
      },
    });

    const res = await test_nonReact();
    expect(res.waitForFragmentData).toEqual({
      firstName: "First",
      onlineStatus: "Online",
    });
  });
});
