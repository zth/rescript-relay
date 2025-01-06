const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const {
  test_prefetchablePagination,
} = require("./Test_prefetchablePagination.bs");

describe("Prefetchable pagination", () => {
  test("prefetching works", async () => {
    queryMock.mockQuery({
      name: "TestPrefetchablePaginationQuery",
      data: {
        loggedInUser: {
          __typename: "User",
          id: "user-1",
          friendsConnection: {
            pageInfo: {
              endCursor: "2",
              hasNextPage: true,
              startCursor: "",
              hasPreviousPage: false,
            },
            edges: [
              {
                cursor: "1",
                node: {
                  id: "user-2",
                  __typename: "User",
                },
              },
              {
                cursor: "2",
                node: {
                  id: "user-3",
                  __typename: "User",
                },
              },
            ],
          },
        },
      },
    });

    queryMock.mockQuery({
      name: "TestPrefetchablePaginationRefetchQuery",
      variables: {
        count: 2,
        cursor: "2",
        id: "user-1",
      },
      data: {
        node: {
          __typename: "User",
          id: "user-1",
          friendsConnection: {
            pageInfo: {
              endCursor: "4",
              hasNextPage: false,
              startCursor: "",
              hasPreviousPage: false,
            },
            edges: [
              {
                cursor: "3",
                node: {
                  id: "user-4",
                  __typename: "User",
                },
              },
              {
                cursor: "4",
                node: {
                  id: "user-5",
                  __typename: "User",
                },
              },
            ],
          },
        },
      },
    });

    t.render(test_prefetchablePagination());
    await t.screen.findByText("user-2, user-3");

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Load more"));
    });

    await t.screen.findByText("user-2, user-3, user-4, user-5");
  });
});
