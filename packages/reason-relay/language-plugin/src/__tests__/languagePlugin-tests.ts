import { Source, parse } from "graphql";
import * as fs from "fs";
import * as path from "path";
import * as RelayReasonGenerator from "../RelayReasonGenerator";
const getLanguagePlugin = require("../index");
import { printCode } from "../generator/Printer.gen";

const CompilerContext = require("relay-compiler/lib/core/CompilerContext");

import * as RelayIRTransforms from "relay-compiler/lib/core/RelayIRTransforms";

import {
  Parser,
  // @ts-ignore
  convertASTDocuments,
  Root,
  Schema,
  Fragment
} from "relay-compiler";

const create = require("relay-compiler").Schema.create;

function parseGraphQLText(
  schema: any,
  text: string
): {
  definitions: ReadonlyArray<Fragment | Root>;
  schema: any;
} {
  const ast = parse(text);
  const extendedSchema = schema.extend(ast);
  const definitions = convertASTDocuments(
    extendedSchema,
    [ast],
    Parser.transform.bind(Parser)
  );
  return {
    definitions,
    schema: extendedSchema
  };
}

const testSchema = create(
  new Source(
    fs.readFileSync(
      path.resolve(path.join(__dirname, "testSchema.graphql")),
      "utf8"
    )
  )
);

function collapseString(str: string) {
  return str.replace(/\r?\n|\r|\t/g, "").replace(/\s+/g, " ");
}

function generate(text: string, options?: any, extraDefs: string = "") {
  const relaySchema = testSchema.extend([
    ...RelayIRTransforms.schemaExtensions,
    ...getLanguagePlugin().schemaExtensions,
    extraDefs
  ]);
  const { definitions, schema: extendedSchema } = parseGraphQLText(
    relaySchema,
    text
  );

  return new CompilerContext(extendedSchema)
    .addAll(definitions)
    .applyTransforms(RelayReasonGenerator.transforms)
    .documents()
    .map(
      (doc: any) =>
        `// ${doc.name}.graphql\n${printCode(
          RelayReasonGenerator.generate(extendedSchema, doc, {
            customScalars: {},
            optionalInputFields: [],
            existingFragmentNames: new Set([]),
            ...options
          })
        )}`
    )
    .join("\n\n");
}

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
        generated.includes("type operationType = ReasonRelay.queryNode;")
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

      expect(generated.includes("type variables = unit;")).toBe(true);
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
          '"__$fragment_ref__SomeComponent_user": SomeComponent_user_graphql.t'
        )
      ).toBe(true);
    });

    it("prints two fragment references", () => {
      let generated = generate(
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
      );

      expect(
        generated.includes(
          '"__$fragment_ref__SomeComponent_user": SomeComponent_user_graphql.t'
        )
      ).toBe(true);

      expect(
        generated.includes(
          '"__$fragment_ref__OtherComponent_user": OtherComponent_user_graphql.t'
        )
      ).toBe(true);
    });

    it("prints many fragment references", () => {
      let generated = generate(
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
      );

      expect(
        generated.includes(
          '"__$fragment_ref__SomeComponent_user": SomeComponent_user_graphql.t'
        )
      ).toBe(true);

      expect(
        generated.includes(
          '"__$fragment_ref__OtherComponent_user": OtherComponent_user_graphql.t'
        )
      ).toBe(true);

      expect(
        generated.includes(
          '"__$fragment_ref__AnotherComponent_user": AnotherComponent_user_graphql.t'
        )
      ).toBe(true);

      expect(
        generated.includes(
          '"__$fragment_ref__LastComponent_user": LastComponent_user_graphql.t'
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
        ).includes("type operationType = ReasonRelay.mutationNode;")
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
        ).includes("type operationType = ReasonRelay.subscriptionNode;")
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
        ).includes("type operationType = ReasonRelay.fragmentNode;")
      ).toBe(true);
    });

    it("handles plural fragments", () => {
      let generated = generate(
        `fragment SomeComponent_user on User @relay(plural: true) {
          id
          firstName
        }`
      );

      expect(
        collapseString(generated).includes(
          `type fragment_t = { id: string, firstName: string,};type fragment = array(fragment_t);`
        )
      ).toBe(true);
    });

    it("prints the correct fragment ref extractor helpers and base types", () => {
      expect(
        generate(
          `fragment SomeComponent_user on User {
            id
          }`
        )
      ).toMatchSnapshot();
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
        generated.includes(
          "type enum_UserRole = [ | `Admin | `User | `FutureAddedValue(string)];"
        )
      ).toBe(true);

      expect(generated.includes(`role: enum_UserRole`)).toBe(true);
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

      expect(generated.includes(`favoriteColor: ReasonRelay.any`)).toBe(true);
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
            Color: "Color.t"
          }
        }
      );

      expect(generated.includes(`favoriteColor: Color.t`)).toBe(true);
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

    it("does not generate a union when there's only one selection", () => {
      let generated = generate(
        `query appQuery {
            participantById(id: "123") {
              __typename
              ... on User {
                id
                firstName
                lastName
                role
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
        `type users = {firstName: string};`
      );

      expect(collapseString(generated)).toMatch(
        `type response = {users: array(users)};`
      );
    });

    it.skip("generates connection helpers when connection is present", () => {
      let generated = generate(
        `query SomeQuery {
          me {
            friendsConnection(first: 2) @connection(key: "SomeQuery_me_friendsConnection") {
              edges {
                node {
                  id
                }
              }
            }
          }
        }`
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
});
