import {
  FragmentDefinitionNode,
  OperationDefinitionNode,
  parse,
  print,
} from "graphql";
import { removeUnusedFieldsFromOperation } from "../cliUtils";

const parseAndExtractOperationDefinition = (
  source: string
): FragmentDefinitionNode | OperationDefinitionNode => {
  const parsed = parse(source);
  if (
    parsed.definitions[0]?.kind === "FragmentDefinition" ||
    parsed.definitions[0]?.kind === "OperationDefinition"
  ) {
    return parsed.definitions[0];
  }

  throw new Error("Definition node not supported.");
};

const printContents = (fragment: string, unusedFieldPaths: string[]) => {
  const res = removeUnusedFieldsFromOperation({
    definition: parseAndExtractOperationDefinition(fragment),
    unusedFieldPaths,
  });

  if (res == null) {
    return "";
  }

  return print(res);
};

describe("Removing unused fields", () => {
  describe("Fragments", () => {
    it("removes simple fields", () => {
      const fragment = `fragment SomeFragment on User {
      someNestedField {
        name
        avatarUrl
        anotherLevel {
          age
          thirdLevel {
            something
          }
        }
      }
    }`;

      const unusedFieldPaths = [
        "someNestedField.avatarUrl",
        "someNestedField_anotherLevel.age",
      ];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  someNestedField {
    name
    anotherLevel {
      thirdLevel {
        something
      }
    }
  }
}`);
    });

    it("removes simple fields at the top level", () => {
      const fragment = `fragment SomeFragment on User {
      id
      name
    }`;

      const unusedFieldPaths = ["name"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  id
}`);
    });

    it("removes full unused fields with selections", () => {
      const fragment = `fragment SomeFragment on User {
      someNestedField {
        name
        anotherLevel {
          age
          thirdLevel {
            something
          }
        }
      }
    }`;

      const unusedFieldPaths = ["someNestedField_anotherLevel"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  someNestedField {
    name
  }
}`);
    });

    it("removes fragment spreads if fragmentRefs is unused", () => {
      const fragment = `fragment SomeFragment on User {
      someNestedField {
        name
        anotherLevel {
          id
          ...SomeFunFragment
          ...AnotherFunFragment
          ...ThirdFragment
        }
      }
    }`;

      const unusedFieldPaths = ["someNestedField_anotherLevel.fragmentRefs"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  someNestedField {
    name
    anotherLevel {
      id
    }
  }
}`);
    });

    it("removes fragment spreads if fragmentRefs is unused, at the top level", () => {
      const fragment = `fragment SomeFragment on User {
      ...SomeFunFragment
      id
    }`;

      const unusedFieldPaths = ["fragmentRefs"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  id
}`);
    });

    it("removes entire fragment if all fields are unused", () => {
      const fragment = `fragment SomeFragment on User {
      id
      name
    }`;

      const unusedFieldPaths = ["id", "name"];

      expect(printContents(fragment, unusedFieldPaths)).toBe("");
    });

    it("removes selections inside of unions", () => {
      const fragment = `fragment SomeFragment on User {
      nested {
        ... on User {
          id
          name
          nested {
            id
            name
          }
        }
        ... on Person {
          id
        }
      }
    }`;

      const unusedFieldPaths = ["nested_User.name", "nested_User_nested.name"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  nested {
    ... on User {
      id
      nested {
        id
      }
    }
    ... on Person {
      id
    }
  }
}`);
    });

    it("removes entire union member if unused", () => {
      const fragment = `fragment SomeFragment on User {
      nested {
        ... on User {
          id
          name
        }
        ... on Person {
          id
        }
      }
    }`;

      const unusedFieldPaths = ["nested_User.name", "nested_User.id"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  nested {
    ... on Person {
      id
    }
  }
}`);
    });

    it("removes selections inside of top level unions", () => {
      const fragment = `fragment SomeFragment on User {
      ... on User {
        id
        name
      }
      ... on Person {
        id
        ...SomePerson_fragment
      }
    }`;

      const unusedFieldPaths = ["User.name", "Person.fragmentRefs"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  ... on User {
    id
  }
  ... on Person {
    id
  }
}`);
    });

    it("removes entire top level union member if unused", () => {
      const fragment = `fragment SomeFragment on User {
      ... on User {
        id
        name
      }
      ... on Person {
        id
      }
    }`;

      const unusedFieldPaths = ["Person.id"];

      expect(printContents(fragment, unusedFieldPaths))
        .toBe(`fragment SomeFragment on User {
  ... on User {
    id
    name
  }
}`);
    });

    describe("Special cases", () => {
      it("adds dummy __typename when all selections for a field is removed, but the field itself is not instructed to be removed", () => {
        /**
         * This happens when no field on the selection is used explicitly, but the
         * existance of the field itself is pattern matched on.
         */
        const fragment = `fragment SomeFragment on User {
    id
    someNestedField {
      name
    }
  }`;

        const unusedFieldPaths = ["someNestedField.name"];

        expect(printContents(fragment, unusedFieldPaths))
          .toBe(`fragment SomeFragment on User {
  id
  someNestedField {
    __typename
  }
}`);
      });
    });
  });

  describe("queries", () => {
    it("removes simple fields", () => {
      const query = `query SomeQuery {
      someNestedField {
        name
        avatarUrl
        anotherLevel {
          age
          thirdLevel {
            something
          }
        }
      }
    }`;

      const unusedFieldPaths = [
        "someNestedField.avatarUrl",
        "someNestedField_anotherLevel.age",
      ];

      expect(printContents(query, unusedFieldPaths)).toBe(`query SomeQuery {
  someNestedField {
    name
    anotherLevel {
      thirdLevel {
        something
      }
    }
  }
}`);
    });

    it("removes simple fields at the top level", () => {
      const query = `query SomeQuery {
      id
      name
    }`;

      const unusedFieldPaths = ["name"];

      expect(printContents(query, unusedFieldPaths)).toBe(`query SomeQuery {
  id
}`);
    });

    it("node interface special treatment", () => {
      const query = `query SingleGoogleCampaignQuery($id: ID!) {
  node(id: $id) {
    __typename
    ... on GoogleAdsCampaign {
      id
      lastSyncedAt
      ...SingleGoogleCampaignDisplay_campaign
    }
  }
}`;

      const unusedFieldPaths = ["node.id", "node.lastSyncedAt"];

      expect(printContents(query, unusedFieldPaths))
        .toBe(`query SingleGoogleCampaignQuery($id: ID!) {
  node(id: $id) {
    __typename
    ... on GoogleAdsCampaign {
      ...SingleGoogleCampaignDisplay_campaign
    }
  }
}`);
    });
  });
});
