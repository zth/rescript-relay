require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_query } = require("./Test_localPayload.bs");

describe("LocalPayload", () => {
  test("committing a local payload works", async () => {
    queryMock.mockQuery({
      name: "TestLocalPayloadQuery",
      variables: {},
      data: {
        loggedInUser: {
          id: "user-1",
          onlineStatus: "Online",
          firstName: "First",
          avatarUrl: "avatar-url",
          memberOf: null,
          memberOfSingular: null,
        },
      },
    });

    t.render(test_query());
    await t.screen.findByText("Firstname: First");
    await t.screen.findByText("Avatar: avatar-url");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Update locally"));
    });

    await t.screen.findByText("Firstname: AnotherFirst");
    await t.screen.findByText("Avatar: -");
    await t.screen.findByText("(singular) Member of: Group Another Group");
  });

  test("commiting a local payload via the Node interface works", async () => {
    queryMock.mockQuery({
      name: "TestLocalPayloadQuery",
      variables: {},
      data: {
        loggedInUser: {
          id: "user-1",
          onlineStatus: "Online",
          firstName: "First",
          avatarUrl: "avatar-url",
          memberOf: null,
          memberOfSingular: null,
        },
      },
    });

    t.render(test_query());
    await t.screen.findByText("Firstname: First");
    await t.screen.findByText("Avatar: avatar-url");

    ReactTestUtils.act(() => {
      t.fireEvent.click(
        t.screen.getByText("Update locally via Node interface")
      );
    });

    await t.screen.findByText("Firstname: AnotherFirst");
    await t.screen.findByText("Avatar: -");
    await t.screen.findByText(
      "Member of: Group Some Group, top member: Some User"
    );
  });
});
