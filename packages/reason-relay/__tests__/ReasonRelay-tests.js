require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_1 } = require("./Test_1.bs");
const { test_2 } = require("./Test_2.bs");

describe("Test_1", () => {
  const getMockedQuery = () => ({
    name: "Test1_Query",
    data: {
      loggedInUser: {
        id: "user-1",
        firstName: "Some",
        lastName: "User",
        avatarUrl: null,
        isOnline: null,
        friendsConnection: null
      }
    }
  });

  describe("query + fragment", () => {
    test("rendering query + fragment works as expected, including loading state with suspense", async () => {
      const resolve = queryMock.mockQueryWithControlledResolution(
        getMockedQuery()
      );

      t.render(test_1().render());
      await t.screen.findByText("Loading...");

      resolve();
      await t.screen.findByText("Some User");
    });
  });

  describe("mutations", () => {
    const getMockedMutation = () => ({
      name: "Test1_AddAvatarMutation",
      variables: {
        avatarUrl: "http://some/avatar.png"
      },
      data: {
        updateUserAvatar: {
          user: {
            id: "user-1",
            avatarUrl: "http://some/avatar.png"
          }
        }
      }
    });

    test("using commitMutation works", async () => {
      queryMock.mockQuery(getMockedQuery());
      queryMock.mockQuery(getMockedMutation());

      t.render(test_1().render());
      await t.screen.findByText("Some User");
      expect(t.screen.queryByAltText("avatar")).toBeNull();

      t.fireEvent.click(t.screen.getByText("Add avatar"));

      await t.screen.findByAltText("avatar");
    });

    test("using commitMutation works with optimistic updates", async () => {
      queryMock.mockQuery(getMockedQuery());
      const resolveMutation = queryMock.mockQueryWithControlledResolution(
        getMockedMutation()
      );

      t.render(test_1().render());
      await t.screen.findByText("Some User");
      expect(t.screen.queryByAltText("avatar")).toBeNull();

      t.fireEvent.click(t.screen.getByText("Add avatar optimistically"));

      await t.screen.findByAltText("avatar");
      resolveMutation();

      await t.screen.findByAltText("avatar");
    });
  });

  describe("refetching + pagination", () => {
    test("simple refetching works", async () => {
      queryMock.mockQuery(getMockedQuery());
      queryMock.mockQuery({
        name: "Test1_UserRefetchQuery",
        variables: {
          id: "user-1",
          showOnlineStatus: true,
          showFriends: false
        },
        data: {
          node: {
            __typename: "User",
            id: "user-1",
            firstName: "Some",
            lastName: "User",
            avatarUrl: null,
            isOnline: true,
            friendsConnection: null
          }
        }
      });

      t.render(test_1().render());
      await t.screen.findByText("Some User");
      expect(t.screen.queryByText("User is online")).toBeNull();

      t.fireEvent.click(t.screen.getByText("Show online status"));

      await t.screen.findByText("User is online");
    });

    test("it's possible to paginate", async () => {
      queryMock.mockQuery(getMockedQuery());
      queryMock.mockQuery({
        name: "Test1_UserRefetchQuery",
        variables: {
          id: "user-1",
          showOnlineStatus: false,
          showFriends: true
        },
        data: {
          node: {
            __typename: "User",
            id: "user-1",
            firstName: "Some",
            lastName: "User",
            avatarUrl: null,
            isOnline: null,
            friendsConnection: {
              pageInfo: {
                hasNextPage: true,
                endCursor: "friend-2"
              },
              edges: [
                {
                  cursor: "friend-1",
                  node: {
                    __typename: "User",
                    id: "friend-1",
                    firstName: "First",
                    lastName: "Friend"
                  }
                },
                {
                  cursor: "friend-2",
                  node: {
                    __typename: "User",
                    id: "friend-2",
                    firstName: "Second",
                    lastName: "Friend"
                  }
                }
              ]
            }
          }
        }
      });

      t.render(test_1().render());
      await t.screen.findByText("Some User");

      t.fireEvent.click(t.screen.getByText("Show friends"));

      await t.screen.findByText("First Friend");
      await t.screen.findByText("Load more friends");

      const resolvePagination = queryMock.mockQueryWithControlledResolution({
        name: "Test1_UserFriendsRefetchQuery",
        variables: {
          id: "user-1",
          count: 2,
          cursor: "friend-2"
        },
        data: {
          node: {
            __typename: "User",
            id: "user-1",
            friendsConnection: {
              pageInfo: {
                hasNextPage: false,
                endCursor: "friend-3"
              },
              edges: [
                {
                  cursor: "friend-3",
                  node: {
                    __typename: "User",
                    id: "friend-3",
                    firstName: "Third",
                    lastName: "Friend"
                  }
                }
              ]
            }
          }
        }
      });

      t.fireEvent.click(t.screen.getByText("Load more friends"));
      await t.screen.findByText("Loading more friends...");

      resolvePagination();

      await t.screen.findByText("Third Friend");
    });
  });
});

describe("Test_2", () => {
  describe("subscriptions", () => {
    test("it handles basic subscriptions", async () => {
      queryMock.mockQuery({
        name: "Test2_Query",
        data: {
          loggedInUser: {
            id: "user-1",
            firstName: "Some",
            lastName: "User",
            avatarUrl: null
          }
        }
      });

      const testAssets = test_2();
      t.render(testAssets.render());
      await t.screen.findByText("Some User");
      expect(t.screen.queryByAltText("avatar")).toBeNull();

      const sink = testAssets.getSink();
      expect(sink).toBeDefined();
      
      sink.next({
        data: {
          userUpdated: {
            user: {
              id: "user-1",
              firstName: "Some",
              lastName: "User",
              avatarUrl: "http://some/avatar.png"
            }
          }
        }
      });

      await t.screen.findByAltText("avatar");
    });
  });
});
