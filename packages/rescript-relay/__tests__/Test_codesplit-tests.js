require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");
const queryMock = require("./queryMock");
const ReactTestUtils = require("react-dom/test-utils");
const query = require("./__generated__/TestCodesplitQuery_graphql.bs");

const { test_codesplit } = require("./Test_codesplit.bs");

describe("Autocodesplits", () => {
  let preloadUserHasRun = false;
  let preloadUserFn;
  const targetUserIndex = query.node.params.metadata.codesplits.findIndex(
    ([p, _]) => p === "member.$$u$$User"
  );

  let preloadHasNameHasRun = false;
  let preloadHasNameFn;
  const targetHasNameIndex = query.node.params.metadata.codesplits.findIndex(
    ([p, _]) => p === "member.$$i$$HasName"
  );

  let preloadLinkedFieldHasRun = false;
  let preloadLinkedFieldFn;
  const targetLinkedFieldIndex =
    query.node.params.metadata.codesplits.findIndex(
      ([p, _]) => p === "member.$$u$$User.description"
    );

  beforeEach(() => {
    // Very hacky way to check if the preload functions has run
    preloadUserFn = query.node.params.metadata.codesplits[targetUserIndex][1];
    query.node.params.metadata.codesplits[targetUserIndex][1] = () => {
      preloadUserHasRun = true;
      return preloadUserFn();
    };

    preloadHasNameFn =
      query.node.params.metadata.codesplits[targetHasNameIndex][1];
    query.node.params.metadata.codesplits[targetHasNameIndex][1] = () => {
      preloadHasNameHasRun = true;
      return preloadHasNameFn();
    };

    preloadLinkedFieldFn =
      query.node.params.metadata.codesplits[targetLinkedFieldIndex][1];
    query.node.params.metadata.codesplits[targetLinkedFieldIndex][1] = () => {
      preloadLinkedFieldHasRun = true;
      return preloadLinkedFieldFn();
    };
  });

  afterEach(() => {
    query.node.params.metadata.codesplits[targetUserIndex][1] = preloadUserFn;
    preloadUserHasRun = false;

    query.node.params.metadata.codesplits[targetHasNameIndex][1] =
      preloadHasNameFn;
    preloadHasNameHasRun = false;

    query.node.params.metadata.codesplits[targetLinkedFieldIndex][1] =
      preloadLinkedFieldFn;
    preloadLinkedFieldHasRun = false;
  });

  test("preload runs when query response matches", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          avatarUrl: "avatar-here",
          description: {
            content: "Rich content!",
          },
        },
      },
    });

    // No preload yet
    expect(preloadUserHasRun).toBe(false);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(false);

    t.render(test_codesplit());

    await t.screen.findByText("Render");

    // Preloads as soon as data has loaded
    expect(preloadUserHasRun).toBe(true);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(true);

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Render"));
    });

    await t.screen.findByText("User avatarUrl: avatar-here");
    await t.screen.findByText("User name: First Last");
    await t.screen.findByText("Rich content: Rich content!");
  });

  test("preload does not run when linked field does not match", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          avatarUrl: "avatar-here",
          description: null,
        },
      },
    });

    expect(preloadUserHasRun).toBe(false);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(false);

    t.render(test_codesplit());

    await t.screen.findByText("Render");

    // Preloads as soon as data has loaded
    expect(preloadUserHasRun).toBe(true);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(false);

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Render"));
    });

    await t.screen.findByText("User avatarUrl: avatar-here");
    await t.screen.findByText("User name: First Last");
  });

  test("preload runs for interface", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      data: {
        member: {
          __typename: "Group",
          id: "group-1",
          name: "A Group",
          __isHasName: "Group",
        },
      },
    });

    // No preload yet
    expect(preloadUserHasRun).toBe(false);
    expect(preloadHasNameHasRun).toBe(false);

    t.render(test_codesplit());

    await t.screen.findByText("Render");

    // No preloads now either
    expect(preloadUserHasRun).toBe(false);
    expect(preloadHasNameHasRun).toBe(true);

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Render"));
    });

    await t.screen.findByText("Group name: A Group");
    await t.screen.findByText("Has name: A Group");
  });
});
