require("@testing-library/jest-dom/extend-expect");
const React = require("react");
const { render, screen, act } = require("@testing-library/react");
const { RelayEnvironmentProvider } = require("react-relay");
const { createMockEnvironment } = require("relay-test-utils");
const { createOperationDescriptor } = require("relay-runtime");
const { Query } = require("./Test_conversionPlan.bs");
const generated = require("./__generated__/TestConversionPlanQuery_graphql.bs");

test("compiler plans preserve nulls, nested list depth and distinct paths through mounted hooks and writes", () => {
  const environment = createMockEnvironment();
  const variables = {
    input: {
      grid: [[[1], undefined, [2]], undefined],
      children: [{ grid: [[[3]]] }, undefined],
    },
  };
  const convertedVariables = Query.convertVariables(variables);
  expect(JSON.parse(JSON.stringify(convertedVariables))).toStrictEqual({
    input: { grid: [[1, null, 2], null], children: [{ grid: [[3]] }, null] },
  });
  const operation = createOperationDescriptor(
    generated.node,
    convertedVariables,
  );
  const date = "2020-01-01T00:00:00.000Z";
  const raw = {
    conversionContract: {
      grid: [[1, null, 2], null],
      dates: [date, null],
      raw: [[[null, { x: null }], null], null],
      a_b: 7,
      a: { b: date },
    },
  };
  environment.commitPayload(operation, raw);
  let data;
  function Probe() {
    data = Query.use(variables, "store-only");
    return React.createElement(
      "div",
      null,
      data.conversionContract.a?.b?.toISOString() ?? "empty",
    );
  }
  render(
    React.createElement(
      RelayEnvironmentProvider,
      { environment },
      React.createElement(
        React.Suspense,
        { fallback: "loading" },
        React.createElement(Probe),
      ),
    ),
  );
  expect(screen.getByText(date)).toBeInTheDocument();
  expect(data.conversionContract).toStrictEqual({
    grid: [[[1], undefined, [2]], undefined],
    dates: [new Date(date), undefined],
    raw: [[[null, { x: null }], undefined], undefined],
    a_b: [7],
    a: { b: new Date(date) },
  });
  expect(environment.lookup(operation.fragment).data).toStrictEqual(raw);
  expect(generated.Internal.convertWrapResponse(data)).toStrictEqual(raw);
  act(() =>
    environment.commitPayload(operation, {
      conversionContract: {
        grid: null,
        dates: null,
        raw: null,
        a_b: null,
        a: null,
      },
    }),
  );
  expect(data.conversionContract).toStrictEqual({
    grid: undefined,
    dates: undefined,
    raw: undefined,
    a_b: undefined,
    a: undefined,
  });
});
