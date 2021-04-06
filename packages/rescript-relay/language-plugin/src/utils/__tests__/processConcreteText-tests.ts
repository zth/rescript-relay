const { processConcreteText } = require("../processConcreteText");

describe("processConcreteText", () => {
  it("replaces require statements correctly", () => {
    expect(
      processConcreteText(
        ` "operation": require('./BookDisplayerRefetchQuery.graphql.re'),
        "someOtherOp": require('./SomeRefetchQuery.graphql.re'),`
      )
    ).toStrictEqual({
      processedText: ` "operation": node_BookDisplayerRefetchQuery,
        "someOtherOp": node_SomeRefetchQuery,`,
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
