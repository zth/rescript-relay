require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_unionFragment } = require("./Test_unionFragment.bs");

describe("Unions on fragments", () => {
  test("basic fragments work", async () => {
    queryMock.mockQuery({
      name: "TestUnionFragmentQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-123",
          firstName: "First",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_unionFragment());
    await t.screen.findByText("First is online");
  });

  test("fragments inside of union fragments work", async () => {
    queryMock.mockQuery({
      name: "TestUnionFragmentQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-123",
          firstName: "First",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_unionFragment());
    await t.screen.findByText("Yup, First is here.");
  });

  test("basic fragments work, plural", async () => {
    queryMock.mockQuery({
      name: "TestUnionFragmentQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-123",
          firstName: "First",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_unionFragment());
    await t.screen.findByText("plural: First is online");
  });

  test("fragments inside of union fragments work, plural", async () => {
    queryMock.mockQuery({
      name: "TestUnionFragmentQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-123",
          firstName: "First",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_unionFragment());
    await t.screen.findByText("plural: Yup, First is here.");
  });
});
