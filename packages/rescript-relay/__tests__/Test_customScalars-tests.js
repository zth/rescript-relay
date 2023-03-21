require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_customScalars } = require("./Test_customScalars.bs");

describe("Custom Scalars", () => {
  test("custom scalars defined as modules are automatically converted", async () => {
    queryMock.mockQuery({
      name: "TestCustomScalarsQuery",
      variables: {
        beforeDate: "2018-01-01T00:00:00.000Z",
        number: 2,
      },
      data: {
        loggedInUser: {
          id: "user-2",
          createdAt: new Date(2020, 1, 1, 0, 0, 0, 0).toJSON(),
          friends: [],
        },
        member: {
          id: "user-1",
          __typename: "User",
          createdAt: new Date(2019, 1, 1, 0, 0, 0, 0).toJSON(),
        },
      },
    });

    t.render(test_customScalars());
    await t.screen.findByText(
      "loggedInUser createdAt: " +
        new Date(2020, 1, 1, 0, 0, 0, 0).getTime().toString()
    );

    await t.screen.findByText(
      "member createdAt: " +
        new Date(2019, 1, 1, 0, 0, 0, 0).getTime().toString()
    );
  });
});
