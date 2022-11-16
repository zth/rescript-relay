require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_fragment } = require("./Test_fragment.bs");

describe("Fragment", () => {
  test("basic fragments work", async () => {
    queryMock.mockQuery({
      name: "TestFragmentQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          onlineStatus: "Online",
          someCustomScalar: `{ "name": "First", "timestamp": "2022-11-16T10:59:57.846Z" }`,
        },
        users: null,
      },
    });

    t.render(test_fragment());
    await t.screen.findByText("First is online and day is 3.0");
  });

  test("plural fragments work", async () => {
    queryMock.mockQuery({
      name: "TestFragmentQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          onlineStatus: "Online",
          someCustomScalar: `{ "name": "First", "timestamp": "2022-11-16T10:59:57.846Z" }`,
        },
        users: {
          edges: [
            {
              node: {
                id: "user-2",
                firstName: "Second",
                onlineStatus: "Online",
              },
            },
            {
              node: {
                id: "user-3",
                firstName: "Third",
                onlineStatus: "Offline",
              },
            },
          ],
        },
      },
    });

    ReactTestUtils.act(() => {
      t.render(test_fragment());
    });
    await t.screen.findByText("Second is online");
    await t.screen.findByText("Third is offline");
  });

  test("optional fragment use hook works", async () => {
    queryMock.mockQuery({
      name: "TestFragmentQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          onlineStatus: "Online",
          someCustomScalar: `{ "name": "First", "timestamp": "2022-11-16T10:59:57.846Z" }`,
        },
        users: null,
      },
    });

    t.render(test_fragment());

    await t.screen.findByText("Opt not activated");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Use opt"));
    });
    await t.screen.findByText("First is here!");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Hide opt"));
    });
    await t.screen.findByText("Opt not activated");
  });

  test("reading fragments inline works", async () => {
    queryMock.mockQuery({
      name: "TestFragmentQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          onlineStatus: "Online",
          someCustomScalar: `{ "name": "First", "timestamp": "2022-11-16T10:59:57.846Z" }`,
        },
        users: null,
      },
    });

    t.render(test_fragment());

    await t.screen.findByText("Set data via inline");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Set data via inline"));
    });
    await t.screen.findByText(
      "Inline data: " +
        JSON.stringify({ firstName: "First", onlineStatus: "Online" })
    );
  });
});
