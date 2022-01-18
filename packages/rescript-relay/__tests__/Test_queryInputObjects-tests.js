require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_queryInputObjects } = require("./Test_queryInputObjects.bs");

describe("Query with input objects", () => {
  test("basic input object conversion works", async () => {
    queryMock.mockQuery({
      name: "TestQueryInputObjectsQuery",
      variables: {
        input: {
          id: 123,
          someOtherId: 1.5,
        },
      },
      data: {
        search: "yup",
      },
    });

    t.render(test_queryInputObjects());
    await t.screen.findByText("yup");
  });
});
