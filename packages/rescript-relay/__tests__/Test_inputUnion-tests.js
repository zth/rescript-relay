require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const { test_inputUnion } = require("./Test_inputUnion.bs");

describe("Query", () => {
  test("conversion of input unions work", async () => {
    queryMock.mockQuery({
      name: "TestInputUnionQuery",
      variables: {
        location: {
          byAddress: {
            city: "City",
          },
        },
      },
      data: {
        findByLocation: "Got it",
      },
    });

    t.render(test_inputUnion());
    await t.screen.findByText("Got it");
  });
});
