import { join, resolve } from "path";
import {
  collapseString,
  generate as generateCurryFunc,
  generateSchema,
} from "../test-utils";

const generate = generateCurryFunc(
  generateSchema(
    resolve(join(__dirname, "..", "test-utils", "testSchema.graphql"))
  )
);

describe("Language plugin tests", () => {
  describe("Query", () => {
    it("prints the correct operationType type", () => {
      let generated = generate(
        `query appQuery($userId: ID!) {
          user(id: $userId) {
            id
            firstName
          }
        }`
      );

      expect(
        generated.includes(
          "type operationType = RescriptRelay.queryNode<relayOperationNode>"
        )
      ).toBe(true);
    });

    it("prints simple responses and variables", () => {
      let generated = generate(
        `query appQuery($userId: ID!) {
            user(id: $userId) {
              id
              firstName
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("prints variables as unit if not variables are supplied", () => {
      let generated = generate(
        `query appQuery {
            me {
              id
              firstName
            }
          }`
      );

      expect(generated.includes("type variables = unit")).toBe(true);
    });

    it("prints single fragment references", () => {
      let generated = generate(
        `
        fragment SomeComponent_user on User {
          id
        }

        query appQuery {
            me {
              id
              firstName
              ...SomeComponent_user
            }
          }`
      );

      expect(
        generated.includes(
          "RescriptRelay.fragmentRefs<[ | #SomeComponent_user]>"
        )
      ).toBe(true);
    });

    it("prints two fragment references", () => {
      let generated = collapseString(
        generate(
          `
        fragment SomeComponent_user on User {
          id
        }

        fragment OtherComponent_user on User {
          id
        }

        query appQuery {
            me {
              id
              firstName
              ...SomeComponent_user
              ...OtherComponent_user
            }
          }`
        )
      );

      expect(
        generated.includes(
          "RescriptRelay.fragmentRefs<[ | #SomeComponent_user | #OtherComponent_user]>"
        )
      ).toBe(true);
    });

    it("prints many fragment references", () => {
      let generated = collapseString(
        generate(
          `
        fragment SomeComponent_user on User {
          id
        }

        fragment OtherComponent_user on User {
          id
        }

        fragment AnotherComponent_user on User {
          id
        }

        fragment LastComponent_user on User {
          id
        }

        query appQuery {
            me {
              id
              firstName
              ...SomeComponent_user
              ...OtherComponent_user
              ...AnotherComponent_user
              ...LastComponent_user
            }
          }`
        )
      );

      expect(
        generated.includes(
          "RescriptRelay.fragmentRefs<[ | #SomeComponent_user | #OtherComponent_user | #AnotherComponent_user | #LastComponent_user]>"
        )
      ).toBe(true);
    });

    describe("connections", () => {
      it("generates helpers for connections with unions", () => {
        const generated = generate(`
        fragment TestPagination_query on Query
          @argumentDefinitions(
            count: { type: "Int", defaultValue: 2 }
            cursor: { type: "String", defaultValue: "" }
          ) {
          participantsConnection(
            first: $count
            after: $cursor
          ) @connection(key: "TestPagination_query_usersConnection") {
            edges {
              node {
                __typename
                ... on User {
                  id
                  firstName
                }
                ... on Observer {
                  id
                  name
                }
              }
            }
          }
        }
    `);

        expect(generated).toMatchSnapshot();
      });

      it("generates helpers for root level connection", () => {
        const generated = generate(`
        fragment TestPagination_query on Query
          @argumentDefinitions(
            count: { type: "Int", defaultValue: 2 }
            cursor: { type: "String", defaultValue: "" }
          ) {
          usersConnection(
            first: $count
            after: $cursor
          ) @connection(key: "TestPagination_query_usersConnection") {
            edges {
              node {
                id
                firstName
              }
            }
          }
        }
    `);

        expect(generated).toMatchSnapshot();
      });

      it("generates helpers for nested connection", () => {
        const generated = generate(`
        fragment TestPagination_query on Query
          @argumentDefinitions(
            count: { type: "Int", defaultValue: 2 }
            cursor: { type: "String", defaultValue: "" }
          ) {
          me {
            friendsConnection(
              first: $count
              after: $cursor
            ) @connection(key: "TestPagination_query_usersConnection") {
              edges {
                node {
                  id
                  firstName
                }
              }
            }
          }
        }
    `);

        expect(generated).toMatchSnapshot();
      });
    });

    it("types ID as dataId for variables piped into the `connections` arg of the store updater directives", () => {
      const generated = generate(`
        mutation SetUserLocationMutation($input: SetUserLocationInput!, $connections: [ID!]!) {
          setUserLocation(input: $input) {
            changedUser @appendNode(connections: $connections) {
              id
              firstName
            }
          }
        }
      `);

      expect(generated).toContain("connections: array<RescriptRelay.dataId>,");
    });

    it("types ID as dataId for variables piped into the `connections` arg of the store updater directives, regardless of what the variable is named", () => {
      const generated = generate(`
        mutation SetUserLocationMutation($input: SetUserLocationInput!, $targetConns: [ID!]!) {
          setUserLocation(input: $input) {
            changedUser @prependNode(connections: $targetConns) {
              id
              firstName
            }
          }
        }
      `);

      expect(generated).toContain("targetConns: array<RescriptRelay.dataId>,");
    });

    it("types ID as dataId for variables targeting single IDs, like @deleteEdge", () => {
      const generated = generate(`
        mutation DeleteUserMutation($userId: ID!, $connections: [ID!]!) {
          deleteUser(userId: $userId) {
            deletedUserId @deleteEdge(connections: $connections)
          }
        }
      `);

      expect(generated).toContain("connections: array<RescriptRelay.dataId>,");
    });
  });

  describe("Mutation", () => {
    it("prints the correct operationType type", () => {
      expect(
        generate(
          `mutation SetUserLocationMutation($input: SetUserLocationInput!) {
            setUserLocation(input: $input) {
              changedUser {
                id
                firstName
              }
            }
          }`
        ).includes(
          "type operationType = RescriptRelay.mutationNode<relayOperationNode>"
        )
      ).toBe(true);
    });

    it("prints the correct basic structure for mutations", () => {
      expect(
        generate(
          `mutation SetUserLocationMutation($input: SetUserLocationInput!) {
            setUserLocation(input: $input) {
              changedUser {
                id
                firstName
              }
            }
          }`
        )
      ).toMatchSnapshot();
    });

    it("generates the correct converter for complex variables", () => {
      let generated = generate(
        `mutation SetUserLocationMutation($input: SetUserLocationInput!) {
            setUserLocation(input: $input) {
              changedUser {
                id
                firstName
                role
              }
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("generates the correct type structure when fragments are included", () => {
      let generated = generate(
        `mutation SetUserLocationMutation($input: SetUserLocationInput!) {
            setUserLocation(input: $input) {
              changedUser {
                ...SomeFragment_user
              }
            }
          }
          
          fragment SomeFragment_user on User {
            firstName
            role
          }`
      );

      expect(generated).toMatchSnapshot();
    });
  });

  describe("Subscription", () => {
    it("prints the correct operationType type", () => {
      expect(
        generate(
          `subscription SomeSubscription($input: UserChangedInput!) {
            userChanged(input: $input) {
              user {
                id
                firstName
              }
            }
          }`
        ).includes(
          "type operationType = RescriptRelay.subscriptionNode<relayOperationNode>"
        )
      ).toBe(true);
    });

    it("prints the correct basic structure for subscriptions", () => {
      const generated = generate(
        `subscription SomeSubscription($input: UserChangedInput!) {
            userChanged(input: $input) {
              user {
                id
                firstName
              }
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });
  });

  describe("Fragment", () => {
    it("prints the correct operationType type", () => {
      expect(
        generate(
          `fragment SomeComponent_user on User {
            id
            firstName
          }`
        ).includes(
          "type operationType = RescriptRelay.fragmentNode<relayOperationNode>"
        )
      ).toBe(true);
    });

    it("handles plural fragments", () => {
      let generated = collapseString(
        generate(
          `fragment SomeComponent_user on User @relay(plural: true) {
          id
          firstName
        }`
        )
      );

      expect(
        generated.includes(
          `type fragment_t = { id: string, firstName: string, } type fragment = array<fragment_t>`
        )
      ).toBe(true);
      expect(
        generated.includes(
          "array<RescriptRelay.fragmentRefs<[> | #SomeComponent_user]>>"
        )
      ).toBe(true);
    });

    it("prints the correct fragment ref extractor helpers and base types", () => {
      let generated = generate(
        `fragment SomeComponent_user on User {
          id
        }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("prints indications of existing fragment refs in generated types", () => {
      let generated = generate(
        `fragment SomeComponent_user on User {
            id
          }
          
          fragment SomeOtherComponent_user on User {
            ...SomeComponent_user
          }`
      );

      expect(generated).toMatchSnapshot();
    });
  });

  describe("Enums", () => {
    it("generates local type for enum and references that", () => {
      let generated = generate(
        `query appQuery {
            me {
              role
            }
          }`
      );

      expect(
        collapseString(generated).includes(
          "type enum_UserRole = private [> | #Admin | #User ]"
        )
      ).toBe(true);

      expect(generated.includes("role: enum_UserRole")).toBe(true);
    });
  });

  describe("Custom scalars", () => {
    it("outputs any unmapped custom scalars as any", () => {
      let generated = generate(
        `query appQuery {
            me {
              favoriteColor
            }
          }`
      );

      expect(generated.includes(`favoriteColor: RescriptRelay.any`)).toBe(true);
    });

    it("handles provided custom scalars", () => {
      let generated = generate(
        `query appQuery {
            me {
              favoriteColor
            }
          }`,
        {
          customScalars: {
            Color: "Color.t",
          },
        }
      );

      expect(generated.includes(`favoriteColor: Color.t`)).toBe(true);
    });

    it("handles automatic conversion when a custom scalar is a module", () => {
      let generated = generate(
        `query appQuery {
            me {
              favoriteColor
            }
          }`,
        {
          customScalars: {
            Color: "Utils.Color",
          },
        }
      );

      expect(generated.includes(`favoriteColor: Utils.Color.t`)).toBe(true);
      expect(generated.includes(`"Utils.Color": Utils.Color.parse`)).toBe(true);
    });
  });

  describe("Unions", () => {
    it("generates code to unwrap unions", () => {
      let generated = generate(
        `query appQuery {
            participantById(id: "123") {
              __typename
              ... on User {
                id
                firstName
                lastName
                location {
                  lat
                  lng
                }
              }

              ... on Observer {
                id
                name
              }
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("handles fragments on unions", () => {
      let generated = generate(
        `fragment Participant_participant on Participant {
            __typename
            ... on User {
              id
              firstName
              lastName
              location {
                id
                lat
                lng
              }
            }

            ... on Observer {
              id
              name
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("generates code to unwrap fragments on unions", () => {
      let generated = generate(
        `
        fragment app_user on User {
          id
          firstName
        }

        fragment app_observer on Observer {
          id
          name
        }

        query appQuery {
            participantById(id: "123") {
              __typename
              ... on User {
                id
                ...app_user
              }

              ... on Observer {
                id
                ...app_observer
              }
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });

    it("handles nested unions", () => {
      let generated = generate(
        `query appQuery {
            participantById(id: "123") {
              __typename
              ... on User {
                id
                firstName
                lastName
              }

              ... on Observer {
                id
                name
                manager {
                  __typename
                  ... on User {
                    id
                    firstName
                    lastName
                  }
                  ... on Observer {
                    id
                    isOnline
                    status
                  }
                }
              }
            }
          }`
      );

      expect(generated).toMatchSnapshot();
    });
  });

  describe("Node interface", () => {
    it("collapses single selections on the node interface", () => {
      let generated = generate(
        `query SomeQuery {
          node(id: "123") {
            __typename
            ... on User {
              firstName
            }
          }
        }`
      );

      expect(generated).toMatchSnapshot();
    });
  });

  describe("Misc", () => {
    it("generates required top level fields as not nullable", () => {
      let generated = generate(
        `query SomeQuery {
          users {
            firstName
          }
        }`
      );

      expect(collapseString(generated)).toMatch(
        `type rec response_users = { firstName: string, }`
      );

      expect(collapseString(generated)).toMatch(
        `type response = { users: array<response_users>, }`
      );
    });

    it("generates all __id selections as dataId type", () => {
      let generated = generate(
        `query SomeQuery {
          __id
          users {
            __id
            friendsConnection(first: 2) {
              __id
              edges {
                __id
                node {
                  __id
                }
              }
            }
          }
        }`
      );

      expect(collapseString(generated)).toContain(
        `response = { __id: RescriptRelay.dataId, users: array<response_users>, }`
      );

      expect(collapseString(generated)).toContain(
        `response_users = { __id: RescriptRelay.dataId, friendsConnection: option<response_users_friendsConnection>, }`
      );

      expect(collapseString(generated)).toContain(
        `response_users_friendsConnection = { __id: RescriptRelay.dataId, edges: option<array<option<response_users_friendsConnection_edges>>>, }`
      );

      expect(collapseString(generated)).toContain(
        `response_users_friendsConnection_edges = { __id: RescriptRelay.dataId, node: option<response_users_friendsConnection_edges_node>, }`
      );

      expect(collapseString(generated)).toContain(
        `response_users_friendsConnection_edges_node = { __id: RescriptRelay.dataId, }`
      );
    });
  });

  describe("Field names", () => {
    describe("Cannot start with uppercase letter", () => {
      it("throws when trying to use a field name starting with an uppercase", () => {
        expect.assertions(2);

        try {
          generate(
            `query SomeQuery {
            Observer(id: "123") {
              id
            }
            Obs: Observer(id: "123") {
              id
            }
          }`
          );
        } catch (e) {
          expect(e).toBeDefined();
          expect(e).toMatchSnapshot();
        }
      });

      it("allows field names starting with uppercase letters when aliased properly", () => {
        generate(
          `query SomeQuery {
          observer: Observer(id: "123") {
            id
          }
        }`
        );
      });
    });

    describe("Reserved keywords", () => {
      it("throws when trying to use a field name that's a reserved keyword", () => {
        expect.assertions(2);

        try {
          generate(
            `query SomeQuery {
              user(id: "123") {
                new
              }
            }`
          );
        } catch (e) {
          expect(e).toBeDefined();
          expect(e).toMatchSnapshot();
        }
      });

      it("allows reserved keywords as field names when aliased properly", () => {
        generate(
          `query SomeQuery {
            user(id: "123") {
              isNew: new
            }
          }`
        );
      });

      it("renames reserved keywords as field names in types when encountered", () => {
        let generated = generate(
          `mutation SomeMutation($input: MutationWithReservedNameInput!) {
            mutationWithReservedName(input: $input)
          }`
        );

        expect(generated).toMatchSnapshot();
      });
    });
  });

  describe("Explicit __typename selection", () => {
    it("throws when selecting a union without an explicit __typename selection", () => {
      expect.assertions(2);

      try {
        generate(
          `query SomeQuery {
            participantById(id: "123") {
              ... on User {
                id
              }

              ... on Observer {
                id
              }
            }
          }`
        );
      } catch (e) {
        expect(e).toBeDefined();
        expect(e).toMatchSnapshot();
      }
    });

    it("allows union when __typename is selected", () => {
      generate(
        `query SomeQuery {
            participantById(id: "123") {
              __typename
              
              ... on User {
                id
              }

              ... on Observer {
                id
              }
            }
          }`
      );
    });
  });

  describe("raw_response_type", () => {
    it("outputs code for handling @raw_response_type", () => {
      let generated = generate(
        `query SomeQuery @raw_response_type {
            me {
              firstName
              lastName
            }
          }          
          `
      );

      expect(generated).toMatchSnapshot();
    });

    it("handles unions in @raw_response_type", () => {
      let generated = generate(
        `query SomeQuery @raw_response_type {
            participantById(id: "123") {
              __typename
              ... on User {
                id
                firstName
              }
            }
          }          
          `
      );

      expect(generated).toMatchSnapshot();
    });

    it("handles the Node interface in @raw_response_type", () => {
      let generated = generate(
        `query SomeQuery @raw_response_type {
            node(id: "123") {
              __typename
              ... on User {
                id
                firstName
              }
            }
          }          
          `
      );

      expect(generated).toMatchSnapshot();
    });
  });
});
