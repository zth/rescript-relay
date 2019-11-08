import { buildSchema, GraphQLSchema, extendSchema, parse } from "graphql";
import * as fs from "fs";
import * as path from "path";
import * as RelayReasonGenerator from "../RelayReasonGenerator";
import { printCode } from "../generator/Printer.gen";

// @ts-ignore
const GraphQLCompilerContext = require("../../../src/vendor/relay-compiler/lib/core/GraphQLCompilerContext");
// @ts-ignore
import * as RelayFlowGenerator from "../../../src/vendor/relay-compiler/lib/language/javascript/RelayFlowGenerator";
// @ts-ignore
import * as RelayIRTransforms from "../../../src/vendor/relay-compiler/lib/core/RelayIRTransforms";

// @ts-ignore
import * as Schema from "../../../src/vendor/relay-compiler/lib/core/Schema";

// @ts-ignore
import { transformASTSchema } from "../../../src/vendor/relay-compiler/lib/core/ASTConvert";

// @ts-ignore
import {
  Parser,
  convertASTDocuments,
  Root,
  Fragment
  // @ts-ignore
} from "../../../src/vendor/relay-compiler";

function parseGraphQLText(
  schema: GraphQLSchema,
  text: string
): {
  definitions: ReadonlyArray<Fragment | Root>;
  schema: GraphQLSchema;
} {
  const ast = parse(text);
  const extendedSchema = extendSchema(schema, ast, { assumeValid: true });
  const definitions = convertASTDocuments(
    Schema.DEPRECATED__create(schema, extendedSchema),
    [ast],
    Parser.transform.bind(Parser)
  );
  return {
    definitions,
    schema: extendedSchema
  };
}

const testSchema = buildSchema(
  fs.readFileSync(
    path.resolve(path.join(__dirname, "testSchema.graphql")),
    "utf8"
  )
);

function collapseString(str: string) {
  return str.replace(/\r?\n|\r|\t/g, "").replace(/\s+/g, " ");
}

function generate(text: string, options?: any, extraDefs: string = "") {
  const relaySchema = transformASTSchema(testSchema, [
    ...RelayIRTransforms.schemaExtensions,
    extraDefs
  ]);
  const { definitions } = parseGraphQLText(relaySchema, text);
  const compilerSchema = Schema.DEPRECATED__create(testSchema, relaySchema);
  return new GraphQLCompilerContext(compilerSchema)
    .addAll(definitions)
    .applyTransforms(RelayReasonGenerator.transforms)
    .documents()
    .map(
      (doc: any) =>
        `// ${doc.name}.graphql\n${printCode(
          RelayReasonGenerator.generate(compilerSchema, doc, {
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
      expect(
        generate(
          `query appQuery($userId: ID!) {
            user(id: $userId) {
              id
              firstName
            }
          }`
        ).includes("type operationType = ReasonRelay.queryNode;")
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

    it("prints nested objects inlined in types", () => {
      let generated = generate(
        `query appQuery($location: LocationBounds!) {
            userByLocation(location: $location) {
              id
              firstName
            }
          }`
      );

      expect(generated).toMatchSnapshot();
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
        )
      ).toMatchSnapshot();
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
          `type fragment = array({ . "firstName": string, "id": string, });`
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
  });

  describe("Enums", () => {
    it("references any enums by global, generated schema assets file", () => {
      let generated = generate(
        `query appQuery {
            me {
              role
            }
          }`
      );

      expect(
        generated.includes(`"role": SchemaAssets.Enum_UserRole.wrapped`)
      ).toBe(true);
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

      expect(generated.includes(`"favoriteColor": ReasonRelay.any`)).toBe(true);
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

      expect(generated.includes(`"favoriteColor": Color.t`)).toBe(true);
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

    it("generates opaque wrapped union types referenced by path in types", () => {
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

      expect(
        generated.includes("type union_response_participantById_wrapped;")
      ).toBe(true);
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
        `type response = {. "users": array({. "firstName": string})};`
      );
    });
  });

  describe("Field names", () => {
    describe("Cannot start with uppercase letter", () => {
      it("throws when trying to use a field name starting with an uppercase", () => {
        expect.assertions(1);

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
        expect.assertions(1);

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
    });
  });
});
