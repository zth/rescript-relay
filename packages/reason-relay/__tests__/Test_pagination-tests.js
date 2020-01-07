require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_pagination } = require("./Test_pagination.bs");

describe("Pagination", () => {
  test("paginating works", async () => {
    queryMock.mockQuery({
      name: "TestPaginationQuery",
      variables: {
        groupId: "123"
      },
      data: {
        members: {
          pageInfo: {
            hasNextPage: true,
            endCursor: "group-1"
          },
          edges: [
            {
              cursor: "user-1",
              node: {
                __typename: "User",
                id: "user-1",
                firstName: "First",
                friendsConnection: {
                  totalCount: 2
                }
              }
            },
            {
              cursor: "group-1",
              node: {
                __typename: "Group",
                id: "group-1",
                name: "Users",
                adminsConnection: {
                  edges: [
                    {
                      node: {
                        id: "user-2",
                        firstName: "Second"
                      }
                    }
                  ]
                }
              }
            }
          ]
        }
      }
    });

    t.render(test_pagination());

    await t.screen.findByText("User First has 2 friends");
    await t.screen.findByText("Group Users with 1 admins");

    queryMock.mockQuery({
      name: "TestPaginationRefetchQuery",
      variables: {
        groupId: "123",
        count: 2,
        onlineStatuses: null,
        cursor: "group-1"
      },
      data: {
        members: {
          pageInfo: {
            hasNextPage: false,
            endCursor: "user-2"
          },
          edges: [
            {
              cursor: "user-2",
              node: {
                __typename: "User",
                id: "user-2",
                firstName: "Second",
                friendsConnection: {
                  totalCount: 4
                }
              }
            }
          ]
        }
      }
    });

    t.fireEvent.click(t.screen.getByText("Load more"));

    await t.screen.findByText("User Second has 4 friends");
  });

  test("refetching the entire connection should work", async () => {
    queryMock.mockQuery({
      name: "TestPaginationQuery",
      variables: {
        groupId: "123"
      },
      data: {
        members: {
          pageInfo: {
            hasNextPage: true,
            endCursor: "user-1"
          },
          edges: [
            {
              cursor: "user-1",
              node: {
                __typename: "User",
                id: "user-1",
                firstName: "First",
                friendsConnection: {
                  totalCount: 2
                }
              }
            }
          ]
        }
      }
    });

    t.render(test_pagination());

    await t.screen.findByText("User First has 2 friends");

    queryMock.mockQuery({
      name: "TestPaginationRefetchQuery",
      variables: {
        groupId: "123",
        onlineStatuses: ["Online", "Idle"],
        count: 2,
        cursor: ""
      },
      data: {
        members: {
          pageInfo: {
            hasNextPage: false,
            endCursor: "user-2"
          },
          edges: [
            {
              cursor: "user-2",
              node: {
                __typename: "User",
                id: "user-2",
                firstName: "Second",
                friendsConnection: {
                  totalCount: 4
                }
              }
            }
          ]
        }
      }
    });

    t.fireEvent.click(t.screen.getByText("Refetch connection"));

    await t.screen.findByText("User Second has 4 friends");
    expect(t.screen.queryByText("User First has 2 friends")).toBeFalsy();
  });
});
