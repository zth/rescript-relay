require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_pagination } = require("./Test_paginationInNode.bs");

describe("Pagination nested in node", () => {
    test("paginating works", async () => {
        queryMock.mockQuery({
            name: "TestPaginationInNodeQuery",
            variables: {
                userId: "123"
            },
            data: {
                node: {
                    id: "123",
                    __typename: "User",
                    firstName: "Gabriel",
                    friendsConnection: {
                        pageInfo: {
                            hasNextPage: true,
                            endCursor: "user-2"
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
                                cursor: "user-2",
                                node: {
                                    __typename: "User",
                                    id: "user-2",
                                    firstName: "Second",
                                    friendsConnection: {
                                        totalCount: 3
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        });

        t.render(test_pagination());

        await t.screen.findByText("User First has 2 friends");
        await t.screen.findByText("User Second has 3 friends");

        queryMock.mockQuery({
            name: "TestPaginationInNodeRefetchQuery",
            variables: {
                id: "123",
                count: 2,
                onlineStatuses: null,
                cursor: "user-2"
            },
            data: {
                node: {
                    id: "123",
                    __typename: "User",
                    friendsConnection: {
                        pageInfo: {
                            hasNextPage: false,
                            endCursor: "user-3"
                        },
                        edges: [
                            {
                                cursor: "user-3",
                                node: {
                                    __typename: "User",
                                    id: "user-3",
                                    firstName: "Third",
                                    friendsConnection: {
                                        totalCount: 4
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        });

        t.fireEvent.click(t.screen.getByText("Load more"));

        await t.screen.findByText("User Third has 4 friends");
    });

    test("refetching the entire connection shouldn't change the non-redefined variables", async () => {
        queryMock.mockQuery({
            name: "TestPaginationInNodeQuery",
            variables: {
                userId: "123"
            },
            data: {
                node: {
                    id: "123",
                    __typename: "User",
                    firstName: "Gabriel",
                    friendsConnection: {
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
            }
        });

        t.render(test_pagination());

        await t.screen.findByText("User First has 2 friends");

        queryMock.mockQuery({
            name: "TestPaginationInNodeRefetchQuery",
            variables: {
                onlineStatuses: ["Online", "Idle"],
                count: 2,
                cursor: "",
                id: "123"
            },
            data: {
                node: {
                    id: "123",
                    __typename: "User",
                    firstName: "Gabriel",
                    friendsConnection: {
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
                                        totalCount: 3
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        });

        t.fireEvent.click(t.screen.getByText("Refetch connection"));

        await t.screen.findByText("User Second has 3 friends");
        expect(t.screen.queryByText("User First has 2 friends")).toBeFalsy();
    });
});
