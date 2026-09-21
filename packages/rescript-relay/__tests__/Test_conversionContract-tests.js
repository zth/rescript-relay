require("@testing-library/jest-dom/extend-expect");
const React = require("react");
const { render, screen, act } = require("@testing-library/react");
const { RelayEnvironmentProvider } = require("react-relay");
const { createMockEnvironment } = require("relay-test-utils");
const { createOperationDescriptor } = require("relay-runtime");
const Scalar = require("./Test_customScalars.bs");
const Fragment = require("./Test_fragment.bs");
const scalarNode =
  require("./__generated__/TestCustomScalarsQuery_graphql.bs").node;
const fragmentNode =
  require("./__generated__/TestFragmentQuery_graphql.bs").node;

function mount(environment, Component) {
  const tree = () =>
    React.createElement(
      RelayEnvironmentProvider,
      { environment },
      React.createElement(
        React.Suspense,
        { fallback: "Loading" },
        React.createElement(Component),
      ),
    );
  const view = render(tree());
  return () => view.rerender(tree());
}

test("compiled query converts nested scalar lists and unions after store updates without changing the store", () => {
  const environment = createMockEnvironment();
  const variables = {
    number: [2],
    beforeDate: new Date("2018-01-01T00:00:00Z"),
  };
  const wireVariables = Scalar.Query.convertVariables(variables);
  expect(wireVariables).toEqual({
    number: 2,
    beforeDate: "2018-01-01T00:00:00.000Z",
  });
  const operation = createOperationDescriptor(scalarNode, wireVariables);
  const date1 = "2020-01-01T00:00:00.000Z";
  const date2 = "2021-01-01T00:00:00.000Z";
  const payload = (date) => ({
    loggedInUser: {
      id: "viewer",
      createdAt: date,
      friends: [{ id: "friend", createdAt: date }],
    },
    member: { __typename: "User", id: "member", createdAt: date },
  });
  environment.commitPayload(operation, payload(date1));
  let converted;
  function Probe() {
    converted = Scalar.Query.use(variables, "store-only");
    return React.createElement(
      "div",
      null,
      converted.loggedInUser.friends[0].createdAt.toISOString(),
    );
  }
  const rerender = mount(environment, Probe);
  expect(screen.getByText(date1)).toBeInTheDocument();
  expect(converted.member.createdAt).toEqual(new Date(date1));
  expect(
    environment.lookup(operation.fragment).data.loggedInUser.friends[0]
      .createdAt,
  ).toBe(date1);
  const first = converted;
  rerender();
  expect(converted).toBe(first); // The real binding's useMemo still applies.
  act(() => environment.commitPayload(operation, payload(date2)));
  expect(screen.getByText(date2)).toBeInTheDocument();
  expect(converted).not.toBe(first);
  expect(converted.member.createdAt).toEqual(new Date(date2));
  expect(first.loggedInUser.friends[0].createdAt).toEqual(new Date(date1));
  expect(environment.lookup(operation.fragment).data.member.createdAt).toBe(
    date2,
  );
});

test("compiled fragment refs can be consumed by nested and plural hooks across nullable store updates", () => {
  const environment = createMockEnvironment();
  const operation = createOperationDescriptor(fragmentNode, {});
  const payload = (status) => ({
    loggedInUser: {
      id: "viewer",
      firstName: "Viewer",
      lastName: "Last",
      onlineStatus: status,
    },
    users: {
      edges: [
        { node: { id: "friend", firstName: "Friend", onlineStatus: status } },
      ],
    },
  });
  environment.commitPayload(operation, payload("Online"));
  let result;
  function Probe() {
    const query = Fragment.Query.use(undefined, "store-only");
    const fragment = Fragment.Fragment.use(query.loggedInUser.fragmentRefs);
    const nested = Fragment.SubFragment.use(fragment.fragmentRefs);
    const plural = Fragment.PluralFragment.use(
      query.users.edges.map((edge) => edge.node.fragmentRefs),
    );
    result = { query, fragment, nested, plural };
    return React.createElement(
      "div",
      null,
      `${nested.lastName}:${plural[0].onlineStatus ?? "none"}`,
    );
  }
  mount(environment, Probe);
  expect(screen.getByText("Last:Online")).toBeInTheDocument();
  expect(result.fragment.updatableFragmentRefs).toBe(
    result.fragment.fragmentRefs,
  );
  expect(result.query.users.edges[0].node.updatableFragmentRefs).toBe(
    result.query.users.edges[0].node.fragmentRefs,
  );
  act(() => environment.commitPayload(operation, payload(null)));
  expect(screen.getByText("Last:none")).toBeInTheDocument();
  expect(result.fragment.onlineStatus).toBeUndefined();
  expect(result.plural[0].onlineStatus).toBeUndefined();
  // The refs still contain the wire value; only the returned data is converted.
  expect(result.query.users.edges[0].node.fragmentRefs.onlineStatus).toBeNull();
  expect(
    environment.lookup(operation.fragment).data.users.edges[0].node
      .onlineStatus,
  ).toBeNull();
});
