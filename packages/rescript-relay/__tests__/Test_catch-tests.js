require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_catch } = require("./Test_catch.bs");

const date = new Date("2025-01-01T06:00");

describe("Catch", () => {
  test("logged in user prop - success", async () => {
    queryMock.mockQuery({
      name: "TestCatchLoggedInUserPropQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          createdAt: date.toISOString(),
          isOnline: null,
        },
      },
    });

    t.render(test_catch("TestLoggedInUserProp"));
    await t.screen.findByText("Got createdAt: 2025-01-01");
  });

  test("logged in user prop - fail", async () => {
    queryMock.mockQuery({
      name: "TestCatchLoggedInUserPropQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          createdAt: null,
          isOnline: null,
        },
      },
      graphqlErrors: [{ path: ["loggedInUser", "createdAt"] }],
    });

    t.render(test_catch("TestLoggedInUserProp"));
    await t.screen.findByText("Error!");
  });

  test("logged in user prop - success but null", async () => {
    queryMock.mockQuery({
      name: "TestCatchLoggedInUserPropQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          createdAt: date.toISOString(),
          isOnline: null,
        },
      },
    });

    t.render(test_catch("TestLoggedInUserProp"));
    await t.screen.findByText("Got isOnline: null");
  });

  test("logged in user prop from fragment - success", async () => {
    queryMock.mockQuery({
      name: "TestCatchLoggedInUserPropQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          createdAt: date.toISOString(),
        },
      },
    });

    t.render(test_catch("TestLoggedInUserPropFragmentData"));
    await t.screen.findByText("Got createdAt: 2025-01-01");
  });

  test("logged in user prop from fragment - fail", async () => {
    queryMock.mockQuery({
      name: "TestCatchLoggedInUserPropQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          createdAt: null,
        },
      },
      graphqlErrors: [{ path: ["loggedInUser", "createdAt"] }],
    });

    t.render(test_catch("TestLoggedInUserPropFragmentData"));
    await t.screen.findByText("Error!");
  });

  test("member prop - success", async () => {
    queryMock.mockQuery({
      name: "TestCatchMemberPropQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          createdAt: date.toISOString(),
        },
      },
    });

    t.render(test_catch("TestMember"));
    await t.screen.findByText("Got user id: user-1, and createdAt: 2025-01-01");
  });

  test("member prop - fail", async () => {
    queryMock.mockQuery({
      name: "TestCatchMemberPropQuery",
      data: {
        member: null,
      },
      graphqlErrors: [{ path: ["member"] }],
    });

    t.render(test_catch("TestMember"));
    await t.screen.findByText("Error!");
  });

  test("member prop - success nested", async () => {
    queryMock.mockQuery({
      name: "TestCatchMemberPropNestedQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          memberOfSingular: {
            __typename: "User",
            id: "user-2",
            createdAt: date.toISOString(),
          },
        },
      },
    });

    t.render(test_catch("TestMemberNested"));
    await t.screen.findByText("Got user id: user-1, and createdAt: 2025-01-01");
  });

  test("member prop - fail nested", async () => {
    queryMock.mockQuery({
      name: "TestCatchMemberPropNestedQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          memberOfSingular: {
            __typename: "User",
            id: "user-2",
            createdAt: null,
          },
        },
      },
      graphqlErrors: [{ path: ["member", "memberOfSingular", "createdAt"] }],
    });

    t.render(test_catch("TestMemberNested"));
    await t.screen.findByText("Error nested!");
  });

  test("members array", async () => {
    queryMock.mockQuery({
      name: "TestCatchMembersPropQuery",
      data: {
        members: {
          edges: [
            {
              __typename: "UserEdge",
              node: {
                __typename: "User",
                id: "user-1",
                createdAt: date.toISOString(),
              },
            },
            {
              __typename: "UserEdge",
              node: {
                __typename: "User",
                id: "user-2",
                createdAt: null,
              },
            },
            {
              __typename: "UserEdge",
              node: {
                __typename: "User",
                id: "user-3",
                createdAt: date.toISOString(),
              },
            },
          ],
        },
      },
      graphqlErrors: [{ path: ["members", "edges", 1, "node", "createdAt"] }],
    });

    t.render(test_catch("TestMembers"));
    await t.screen.findByText(
      "User: user-1 - 2025-01-01, Error!, User: user-3 - 2025-01-01"
    );
  });
});
