require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_nodeInterface } = require("./Test_nodeInterface.bs");

describe("Node interface", () => {
  test("collapsed when only one sub selection exists", async () => {
    queryMock.mockQuery({
      name: "TestNodeInterfaceQuery",
      data: {
        node: {
          __typename: "User",
          firstName: "First",
          id: "123",
        },
      },
    });

    t.render(test_nodeInterface());
    await t.screen.findByText("First");
  });

  test("nulls node when not of matching type", async () => {
    queryMock.mockQuery({
      name: "TestNodeInterfaceQuery",
      data: {
        node: {
          __typename: "Group",
          firstName: "First",
          id: "123",
        },
      },
    });

    t.render(test_nodeInterface());
    await t.screen.findByText("-");
  });
});
