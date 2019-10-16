const { processConcreteText } = require("../processConcreteText");

describe("processConcreteText", () => {
  it("replaces require statements correctly", () => {
    expect(
      processConcreteText(
        ` "operation": require('./BookDisplayerRefetchQuery.graphql.re').node,
        "someOtherOp": require('./SomeRefetchQuery.graphql.re').node,`
      )
    ).toBe(
      ` "operation": require('./BookDisplayerRefetchQuery_graphql.bs.js').node,
        "someOtherOp": require('./SomeRefetchQuery_graphql.bs.js').node,`
    );
  });
});
