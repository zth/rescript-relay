const { processConcreteText } = require("../processConcreteText");

describe("processConcreteText", () => {
  it("replaces require statements correctly", () => {
    expect(
      processConcreteText(
        ` "operation": require('./BookDisplayerRefetchQuery.graphql'),
        "someOtherOp": require('./SomeRefetchQuery.graphql'),`
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
