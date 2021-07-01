import { FragmentDefinitionNode, parse, print } from "graphql";
import { removeUnusedFieldsFromFragment } from "../cliUtils";

const parseAndExtractFragmentDefinition = (
  source: string
): FragmentDefinitionNode => {
  const parsed = parse(source);
  if (parsed.definitions[0]?.kind !== "FragmentDefinition") {
    throw new Error("Not a valid fragment");
  }

  return parsed.definitions[0];
};

const printContents = (fragment: string, unusedFieldPaths: string[]) => {
  const res = removeUnusedFieldsFromFragment({
    definition: parseAndExtractFragmentDefinition(fragment),
    unusedFieldPaths,
  });

  if (res == null) {
    return "";
  }

  return print(res);
};

describe("Removing unused fields", () => {
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
      }
    }`;

    const unusedFieldPaths = ["User.name"];

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
});
