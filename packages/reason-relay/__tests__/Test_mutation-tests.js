require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_mutation } = require("./Test_mutation.bs");

describe("Mutation", () => {
  test("basic mutations work via commitMutation", async () => {
    queryMock.mockQuery({
      name: "TestMutationQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Name",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_mutation());
    await t.screen.findByText("First is online");

    queryMock.mockQuery({
      name: "TestMutationSetOnlineStatusMutation",
      variables: {
        onlineStatus: "Idle",
      },
      data: {
        setOnlineStatus: {
          user: {
            id: "user-1",
            firstName: "First",
            lastName: "Name",
            onlineStatus: "Idle",
          },
        },
      },
    });

    t.fireEvent.click(t.screen.getByText("Change online status"));

    await t.screen.findByText("First is idle");
  });

  test("basic mutations work via useMutation hook", async () => {
    queryMock.mockQuery({
      name: "TestMutationQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Name",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_mutation());
    await t.screen.findByText("First is online");

    const resolveQuery = queryMock.mockQueryWithControlledResolution({
      name: "TestMutationSetOnlineStatusMutation",
      variables: {
        onlineStatus: "Idle",
      },
      data: {
        setOnlineStatus: {
          user: {
            id: "user-1",
            firstName: "First",
            lastName: "Name",
            onlineStatus: "Idle",
          },
        },
      },
    });

    t.fireEvent.click(
      t.screen.getByText("Change online status via useMutation hook")
    );

    await t.screen.findByText("Mutating...");

    resolveQuery();

    await t.screen.findByText("First is idle");
  });

  test("mutation with complex input is converted", async () => {
    queryMock.mockQuery({
      name: "TestMutationQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Name",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_mutation());
    await t.screen.findByText("First is online");

    queryMock.mockQuery({
      name: "TestMutationSetOnlineStatusComplexMutation",
      variables: {
        input: {
          onlineStatus: "Idle",
        },
      },
      data: {
        setOnlineStatusComplex: {
          user: {
            id: "user-1",
            onlineStatus: "Idle",
          },
        },
      },
    });

    t.fireEvent.click(t.screen.getByText("Change online status, complex"));

    await t.screen.findByText("First is idle");
  });

  test("optimistic response works", async () => {
    queryMock.mockQuery({
      name: "TestMutationQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Name",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_mutation());
    await t.screen.findByText("First is online");

    const resolve = queryMock.mockQueryWithControlledResolution({
      name: "TestMutationSetOnlineStatusMutation",
      variables: {
        onlineStatus: "Idle",
      },
      data: {
        setOnlineStatus: {
          user: {
            id: "user-1",
            firstName: "First",
            lastName: "Name",
            onlineStatus: "Idle",
          },
        },
      },
    });

    t.fireEvent.click(
      t.screen.getByText("Change online status with optimistic update")
    );

    await t.screen.findByText("First is idle");
    resolve();
    await t.screen.findByText("First is idle");
  });

  test("mutation responses are converted correctly", async () => {
    queryMock.mockQuery({
      name: "TestMutationQuery",
      data: {
        loggedInUser: {
          id: "user-1",
          firstName: "First",
          lastName: "Name",
          onlineStatus: "Online",
        },
      },
    });

    t.render(test_mutation());
    await t.screen.findByText("First is online");

    queryMock.mockQuery({
      name: "TestMutationSetOnlineStatusMutation",
      variables: {
        onlineStatus: "Idle",
      },
      data: {
        setOnlineStatus: {
          user: {
            id: "user-1",
            firstName: "First",
            lastName: "Name",
            onlineStatus: "Idle",
          },
        },
      },
    });

    t.fireEvent.click(t.screen.getByText("Change online status with updater"));

    await t.screen.findByText("First is offline");
  });
});
