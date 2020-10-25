import { find } from "../FindGraphQLTags";

describe("Language plugin tests", () => {
  describe("ReScript Syntax", () => {
    describe("Query", () => {
      it("parses graphql query with variable", () => {
        let parsed = find(
          "module Query = %relay.query(       \
            `                                 \
              query appQuery($userId: ID!) {  \
                user(id: $userId) {           \
                  id                          \
                  firstName                   \
                }                             \
              }                               \
            `                                 \
          )"
          ,
          "test"
        );

        expect(
          parsed.length
        ).toBeGreaterThan(0);
      });
    });

    describe("Mutation", () => {});

    describe("Subscription", () => {});

    describe("Fragment", () => {});
  });
});
