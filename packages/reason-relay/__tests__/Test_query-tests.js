require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

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

    t.fireEvent.click(t.screen.getByText("Switch to offline"));

    queryMock.mockQuery(
      makeMockedQuery({ status: null }, [
        { id: "user-1", firstName: "First", onlineStatus: "Idle" },
        { id: "user-2", firstName: "Second", onlineStatus: "SomeOtherValue" },
        { id: "user-3", firstName: "Third", onlineStatus: null },
      ])
    );

    t.fireEvent.click(t.screen.getByText("Switch to all statuses"));

    await t.screen.findByText("First is idle");
    await t.screen.findByText("Second is -");
    await t.screen.findByText("Third is -");
  });

  test("using preloaded version works", async () => {
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

    t.fireEvent.click(t.screen.getByText("Test preloaded"));

    await t.screen.findByText("Preloaded Second is idle");
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

    t.fireEvent.click(t.screen.getByText("Test preloaded from raw module"));

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

    t.fireEvent.click(t.screen.getByText("Test fetch"));

    await t.screen.findByText("Fetched!");
  });

  test("using fetch promised version works", async () => {
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

    t.fireEvent.click(t.screen.getByText("Test fetch promised"));

    await t.screen.findByText("Fetched!");
  });
});
