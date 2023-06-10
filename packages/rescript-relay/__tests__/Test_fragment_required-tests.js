require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_fragment_required } = require("./Test_fragment_required.bs");

describe("Fragments with required", () => {
  describe("Required can bubble to the top level", () => {
    test("with data", async () => {
      queryMock.mockQuery({
        name: "TestFragmentRequiredQuery",
        data: {
          loggedInUser: {
            id: "user-1",
            onlineStatus: "Online",
          },
          users: null,
        },
      });

      t.render(test_fragment_required());
      await t.screen.findByText("Plain fragment: Online");
    });

    test("nulled", async () => {
      queryMock.mockQuery({
        name: "TestFragmentRequiredQuery",
        data: {
          loggedInUser: {
            id: "user-1",
            onlineStatus: null,
          },
          users: null,
        },
      });

      t.render(test_fragment_required());
      await t.screen.findByText("Plain fragment: not found");
    });
  });

  describe("Required for plurals bubble to the array item level, but not beyond", () => {
    test("with data", async () => {
      queryMock.mockQuery({
        name: "TestFragmentRequiredQuery",
        data: {
          loggedInUser: {
            id: "user-1",
            onlineStatus: "Online",
          },
          users: {
            edges: [
              {
                node: {
                  id: "user-2",
                  onlineStatus: "Online",
                },
              },
              {
                node: {
                  id: "user-3",
                  onlineStatus: "offline",
                },
              },
              {
                node: {
                  id: "user-4",
                  onlineStatus: null,
                },
              },
            ],
          },
        },
      });

      t.render(test_fragment_required());
      await t.screen.findByText("Non null count: 2");
      await t.screen.findByText("Null count: 1");
      await t.screen.findByText("Users: Online, Offline");
    });
  });
});
