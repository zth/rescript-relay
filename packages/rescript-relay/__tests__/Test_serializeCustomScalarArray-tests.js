require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");

const {
  test_serializeCustomScalarArray,
} = require("./Test_serializeCustomScalarArray.bs");

describe("Serialize Custom Scalar Array", () => {
  test("serializes custom scalar array", async () => {
    const logSpy = jest.spyOn(console, "log");
    t.render(test_serializeCustomScalarArray());

    const resolveQuery = queryMock.mockQueryWithControlledResolution({
      name: "TestSerializeCustomScalarArrayMutation",
      variables: {
        input: [97, 98, 99],
      },
      data: {
        serializeCustomScalarArray: {
          works: true,
        },
      },
    });

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Fire mutation"));
    });

    await t.screen.findByText("Mutating...");

    ReactTestUtils.act(() => {
      resolveQuery();
    });

    expect(logSpy).toHaveBeenCalledTimes(3);
    expect(logSpy).toHaveBeenNthCalledWith(1, "serialize", 97);
    expect(logSpy).toHaveBeenNthCalledWith(2, "serialize", 98);
    expect(logSpy).toHaveBeenNthCalledWith(3, "serialize", 99);
  });
});
