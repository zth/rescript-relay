const React = require("react");
const { render, act } = require("@testing-library/react");
const { RelayEnvironmentProvider } = require("react-relay");
const { createMockEnvironment } = require("relay-test-utils");
const { createOperationDescriptor } = require("relay-runtime");
const { Query, Fragment, CatchFragment, caughtDates } = require("./Test_conversionPlural.bs");
const { node } = require("./__generated__/TestConversionPluralQuery_graphql.bs");

test("plural fragments convert custom scalars, including inside catch results, across store updates", () => {
  const environment = createMockEnvironment();
  const operation = createOperationDescriptor(node, {});
  const dates = ["2020-01-01T00:00:00.000Z", "2021-01-01T00:00:00.000Z"];
  const payload = values => ({
    users: {
      edges: values.map((createdAt, index) => ({
        node: { id: String(index), createdAt, firstName: `User ${index}` },
      })),
    },
  });
  environment.commitPayload(operation, payload(dates));
  let plain, caught;
  function Probe() {
    const query = Query.use(undefined, "store-only");
    const refs = query.users.edges.map(edge => edge.node.fragmentRefs);
    plain = Fragment.use(refs);
    caught = CatchFragment.use(refs);
    return null;
  }
  render(React.createElement(RelayEnvironmentProvider, {environment}, React.createElement(Probe)));
  const check = values => {
    expect(plain.map(value => value.createdAt)).toEqual(values.map(value => new Date(value)));
    expect(caught.map(value => value.ok)).toEqual(values.map(() => true));
    expect(caughtDates(caught)).toEqual(values);
    expect(values.map((_, index) =>
      environment.getStore().getSource().get(String(index)).createdAt,
    )).toEqual(values);
  };
  check(dates);
  const firstPlain = plain;
  const firstCaught = caught;
  const updated = dates.slice().reverse();
  act(() => environment.commitPayload(operation, payload(updated)));
  check(updated);
  expect(plain).not.toBe(firstPlain);
  expect(caught).not.toBe(firstCaught);
  expect(firstPlain.map(value => value.createdAt)).toEqual(dates.map(value => new Date(value)));
  expect(caughtDates(firstCaught)).toEqual(dates);

  const mixed = payload(dates);
  mixed.users.edges[0].node.firstName = null;
  act(() => environment.commitPayload(operation, mixed));
  expect(caught.map(value => value.ok)).toEqual([false, true]);
  expect(caught[0].errors).toHaveLength(1);
  expect(caughtDates(caught)).toEqual([undefined, dates[1]]);
  expect(plain.map(value => value.createdAt)).toEqual(dates.map(value => new Date(value)));
  expect(environment.getStore().getSource().get("0").firstName).toBeNull();
  expect(environment.getStore().getSource().get("1").createdAt).toBe(dates[1]);
});
