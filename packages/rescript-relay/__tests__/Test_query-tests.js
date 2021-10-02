require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const { test_query } = require("./Test_query.bs");

describe("Query", () => {
  const makeMockedQuery = (variables, users) => ({
    name: "TestQuery",
    variables,
    data: {
      users: {
        edges: users.map((u) => ({
          node: u,
        })),
      },
    },
  });

  test("basic conversion of variables + response work, and None values in variables are sent as null", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Offline",
        },
        [{ id: "user-2", firstName: "Second", onlineStatus: "Offline" }]
      )
    );

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Switch to offline"));
    });

    queryMock.mockQuery(
      makeMockedQuery({ status: null }, [
        { id: "user-1", firstName: "First", onlineStatus: "Idle" },
        { id: "user-2", firstName: "Second", onlineStatus: "SomeOtherValue" },
        { id: "user-3", firstName: "Third", onlineStatus: null },
      ])
    );

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Switch to all statuses"));
    });

    await t.screen.findByText("First is idle");
    await t.screen.findByText("Second is -");
    await t.screen.findByText("Third is -");
  });

  test("using preloaded directly from raw module works", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Idle",
        },
        [{ id: "user-2", firstName: "Second", onlineStatus: "Idle" }]
      )
    );

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test preloaded from raw module"));
    });

    await t.screen.findByText("Preloaded Second is idle");
  });

  test("converting preloaded token to promise and waiting for that works", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Idle",
        },
        [{ id: "user-2", firstName: "Second", onlineStatus: "Idle" }]
      )
    );

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test wait for preload"));
    });

    await t.screen.findByText("Has waited for preload");
    await t.screen.findByText("Preloaded Second is idle");
  });

  test("using fetch version works", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test fetch"));
    });

    await t.screen.findByText("Fetched!");
  });

  test("using fetchPromised version works", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test fetch promised"));
    });

    await t.screen.findByText("Fetched!");
  });

  test("using query loader works", async () => {
    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Online",
        },
        [{ id: "user-1", firstName: "First", onlineStatus: "Online" }]
      )
    );

    t.render(test_query());
    await t.screen.findByText("First is online");

    queryMock.mockQuery(
      makeMockedQuery(
        {
          status: "Idle",
        },
        [{ id: "user-2", firstName: "Second", onlineStatus: "Idle" }]
      )
    );

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Test query loader"));
    });

    await t.screen.findByText("Preloaded Second is idle");
  });
});
