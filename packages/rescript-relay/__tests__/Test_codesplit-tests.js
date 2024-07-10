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

  let preloadBestFriendDescriptionHasRun = false;
  let preloadBestFriendDescriptionFn;
  const targetBestFriendDescriptionIndex =
    query.node.params.metadata.codesplits.findIndex(
      ([p, _]) => p === "member.$$u$$User.bestFriend.description"
    );

  beforeEach(() => {
    // Very hacky way to check if the preload functions has run
    preloadUserFn = query.node.params.metadata.codesplits[targetUserIndex][1];
    query.node.params.metadata.codesplits[targetUserIndex][1] = (v) => {
      preloadUserHasRun = true;
      return preloadUserFn(v);
    };

    preloadHasNameFn =
      query.node.params.metadata.codesplits[targetHasNameIndex][1];
    query.node.params.metadata.codesplits[targetHasNameIndex][1] = (v) => {
      preloadHasNameHasRun = true;
      return preloadHasNameFn(v);
    };

    preloadLinkedFieldFn =
      query.node.params.metadata.codesplits[targetLinkedFieldIndex][1];
    query.node.params.metadata.codesplits[targetLinkedFieldIndex][1] = (v) => {
      preloadLinkedFieldHasRun = true;
      return preloadLinkedFieldFn(v);
    };

    preloadBestFriendDescriptionFn =
      query.node.params.metadata.codesplits[
        targetBestFriendDescriptionIndex
      ][1];
    query.node.params.metadata.codesplits[targetBestFriendDescriptionIndex][1] =
      (v) => {
        if (v.includeBestFriendDescription) {
          preloadBestFriendDescriptionHasRun = true;
          return preloadBestFriendDescriptionFn(v);
        }
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

    query.node.params.metadata.codesplits[targetBestFriendDescriptionIndex][1] =
      preloadBestFriendDescriptionFn;
    preloadBestFriendDescriptionHasRun = false;
  });

  test("preload runs when query response matches", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      variables: {
        includeBestFriendDescription: true,
      },
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
          bestFriend: {
            __typename: "User",
            id: "user-2",
            description: {
              content: "Rich content?",
            },
          },
        },
      },
    });

    // No preload yet
    expect(preloadUserHasRun).toBe(false);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(false);
    expect(preloadBestFriendDescriptionHasRun).toBe(false);

    t.render(test_codesplit());

    await t.screen.findByText("Render");

    // Preloads as soon as data has loaded
    expect(preloadUserHasRun).toBe(true);
    expect(preloadHasNameHasRun).toBe(false);
    expect(preloadLinkedFieldHasRun).toBe(true);
    expect(preloadBestFriendDescriptionHasRun).toBe(true);

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Render"));
    });

    await t.screen.findByText("User avatarUrl: avatar-here");
    await t.screen.findByText("User name: First Last");
    await t.screen.findByText("Rich content: Rich content!");
    await t.screen.findByText("Rich content: Rich content?");
  });

  test("handles when conditionals exclude but the underlying content matches", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      variables: {
        includeBestFriendDescription: false,
      },
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
          bestFriend: {
            __typename: "User",
            id: "user-2",
            description: {
              content: "Rich content?",
            },
          },
        },
      },
    });

    // No preload yet
    expect(preloadBestFriendDescriptionHasRun).toBe(false);

    t.render(test_codesplit(false));

    await t.screen.findByText("Render");

    // Preloads as soon as data has loaded
    expect(preloadBestFriendDescriptionHasRun).toBe(false);

    ReactTestUtils.act(() => {
      t.fireEvent.click(t.screen.getByText("Render"));
    });

    await t.screen.findByText("User avatarUrl: avatar-here");
  });

  test("preload does not run when linked field does not match", async () => {
    queryMock.mockQuery({
      name: "TestCodesplitQuery",
      variables: {
        includeBestFriendDescription: true,
      },
      data: {
        member: {
          __typename: "User",
          id: "user-1",
          firstName: "First",
          lastName: "Last",
          avatarUrl: "avatar-here",
          description: null,
          bestFriend: null,
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
      variables: {
        includeBestFriendDescription: true,
      },
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
