const { processConcreteText } = require("../processConcreteText");

describe("processConcreteText", () => {
  it("replaces require statements correctly", () => {
    expect(
      processConcreteText(
        ` "operation": require('./BookDisplayerRefetchQuery.graphql.re'),
        "someOtherOp": require('./SomeRefetchQuery.graphql.re'),`
      )
    ).toStrictEqual({
      processedText: ` "operation": BookDisplayerRefetchQuery_graphql.node,
        "someOtherOp": SomeRefetchQuery_graphql.node,`,
      referencedNodes: [
        {
          identifier: "node_BookDisplayerRefetchQuery",
          moduleName: "BookDisplayerRefetchQuery",
        },
        {
          identifier: "node_SomeRefetchQuery",
          moduleName: "SomeRefetchQuery",
        },
      ],
    });
  });
});
