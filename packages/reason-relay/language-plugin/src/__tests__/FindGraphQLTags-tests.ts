import { stripIgnoredCharacters } from "graphql";
import { join, resolve } from "path";
import { SourceLocation } from "relay-compiler/lib/core/IR";
import { find } from "../FindGraphQLTags";
import {
  generateRelaySchema,
  generateSchema,
  parseGraphQLText,
} from "../test-utils";

const relaySchema = generateRelaySchema(
  generateSchema(
    resolve(join(__dirname, "..", "test-utils", "testSchema.graphql"))
  )
);

const fragment = `
fragment SomeComponent_user on User {
  id
}
`;

const query = `
query appQuery($userId: ID!) {
  user(id: $userId) {
    id
    firstName
  }
}
`;

describe("Language plugin tests", () => {
  describe("RelayFindGraphQLTags", () => {
    describe("ReScript Syntax", () => {
      it("parses graphql templates", () => {
        const graphqlTags = find(
          `
            module Fragment = %relay.fragment(
              \`
                ${fragment}
              \`
            )

            module Query = %relay.query(
              \`
                ${query}
              \`
            )
          `,
          "test"
        );

        const parsedBodies = graphqlTags.map((tag) => {
          const { definitions, schema } = parseGraphQLText(
            relaySchema,
            tag.template
          );

          return definitions && definitions.length && schema
            ? stripIgnoredCharacters(
                ((definitions[0] as any).loc as SourceLocation).source.body
              )
            : undefined;
        });

        expect(parsedBodies).toEqual([
          stripIgnoredCharacters(fragment),
          stripIgnoredCharacters(query),
        ]);
      });
      // describe("ReScript Syntax", () => {});
    });
  });
});
