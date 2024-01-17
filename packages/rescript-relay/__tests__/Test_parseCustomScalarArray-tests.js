require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");

const {
  test_parseCustomScalarArray,
} = require("./Test_parseCustomScalarArray.bs");

describe("Parse Custom Scalar Array", () => {
  test("array of a custom scalars defined as modules are automatically converted", async () => {
    queryMock.mockQuery({
      name: "TestParseCustomScalarArrayQuery",
      data: {
        loggedInUser: {
          id: "user-2",
          intStrings: ["1", "2", "3"],
          intString: "9",
          justStrings: ["10", "20", "30"],
          justString: "99",
        },
      },
    });

    t.render(test_parseCustomScalarArray());

    await t.screen.findByText("10, 20, 30");
    await t.screen.findByText("9");
    await t.screen.findByText("99");
    await t.screen.findByText("1, 2, 3");
  });
});
