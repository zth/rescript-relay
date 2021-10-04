require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const queryMock = require("./queryMock");

const { test_unions } = require("./Test_unions.bs");

describe("Unions", () => {
  test("deep conversion of unions, enums and nullables", async () => {
    queryMock.mockQuery({
      name: "TestUnionsQuery",
      data: {
        members: {
          edges: [
            {
              node: {
                __typename: "User",
                id: "user-1",
                firstName: "First",
                onlineStatus: null,
              },
            },
            {
              node: {
                __typename: "User",
                id: "user-2",
                firstName: "Second",
                onlineStatus: "Offline",
              },
            },
            {
              node: {
                __typename: "Group",
                id: "group-1",
                name: "Group #1",
                avatarUrl: null,
                members: [
                  {
                    __typename: "User",
                    id: "user-3",
                    firstName: "Third",
                    onlineStatus: "Idle",
                  },
                  {
                    __typename: "Group",
                    id: "group-2",
                    name: "Group #2",
                    avatarUrl: "group2_avatar",
                  },
                ],
              },
            },
          ],
        },
      },
    });

    t.render(test_unions());
    await t.screen.findByText("First level: First is [no status]");
    await t.screen.findByText("First level: Second is offline");
    await t.screen.findByText(
      "First level: Group #1 with avatarUrl [no avatar]"
    );
    await t.screen.findByText("Second level: Third is idle");
    await t.screen.findByText(
      "Group #1 - Second level: Group #2 with avatarUrl group2_avatar"
    );
  });
});
