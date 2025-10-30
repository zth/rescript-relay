const { traverser } = require("../src/utils");

describe("conversion", () => {
  it("handles nullables at various levels", () => {
    expect(
      traverser(
        {
          me: {
            name: "Name",
            age: null,
            nicknames: [null, "SomeName"],
            nestedObjects: [{ someProp: null, otherProp: "Lars" }, null],
          },
          otherProp: null,
        },
        {
          __root: {
            "": {
              f: "",
            },
            otherProp: {
              n: "",
            },
            me: {
              n: "",
              f: "",
            },
            me_age: {
              n: "",
            },
            me_nicknames: {
              n: "",
            },
            me_nestedObjects: {
              n: "",
              f: "",
            },
            me_nestedObjects_someProp: {
              n: "",
            },
          },
        },
        {},
        undefined
      )
    ).toEqual({
      fragmentRefs: expect.any(Object),
      updatableFragmentRefs: expect.any(Object),
      me: {
        fragmentRefs: expect.any(Object),
        updatableFragmentRefs: expect.any(Object),
        name: "Name",
        age: undefined,
        nicknames: [undefined, "SomeName"],
        nestedObjects: [
          {
            someProp: undefined,
            otherProp: "Lars",
            fragmentRefs: expect.any(Object),
            updatableFragmentRefs: expect.any(Object),
          },
          undefined,
        ],
      },
      otherProp: undefined,
    });
  });

  it("does not produce circular references", () => {
    let traversedObj = traverser(
      {
        otherProp: null,
      },
      {
        __root: {
          "": {
            f: "",
          },
          otherProp: {
            n: "",
          },
        },
      },
      {},
      undefined
    );

    try {
      expect(JSON.stringify(traversedObj)).toBeDefined();
    } catch (e) {
      console.error(e);
    }

    expect.assertions(1);
  });

  it("handles converting enums", () => {
    expect(
      traverser(
        {
          ageRange: "999",
          me: {
            name: "Name",
            ageRange: "123",
            ageRanges: [null, "234"],
            nestedObjects: [{ someProp: null, otherProp: "345" }, null],
          },
        },
        {
          __root: {
            ageRange: {
              e: "enum_Enum",
            },
            me_ageRange: {
              n: "",
              e: "enum_Enum",
            },
            me_ageRanges: {
              n: "",
              e: "enum_Enum",
            },
            me_nestedObjects: {
              n: "",
            },
            me_nestedObjects_someProp: {
              n: "",
            },
            me_nestedObjects_otherProp: {
              n: "",
              e: "enum_Enum",
            },
          },
        },
        {
          enum_Enum: (v) => parseInt(v, 10),
        },
        undefined
      )
    ).toEqual({
      ageRange: 999,
      me: {
        name: "Name",
        ageRange: 123,
        ageRanges: [undefined, 234],
        nestedObjects: [
          {
            someProp: undefined,
            otherProp: 345,
          },
          undefined,
        ],
      },
      otherProp: undefined,
    });
  });

  it("handles converting unions, including nested unions", () => {
    expect(
      traverser(
        {
          someUnion: {
            __typename: "User",
            firstName: "First",
            ageRange: "123",
            meta: {
              ageRange: "234",
              nullable: null,
            },
          },
          friends: [
            null,
            {
              __typename: "User",
              firstName: "First",
              ageRange: "123",
              meta: {
                ageRange: "234",
                nullable: null,
              },
            },
            {
              __typename: "Observer",
              name: null,
              ageRange: "345",
              meta: {
                ageRange: "456",
                nullable: null,
              },
              friends: [
                null,
                {
                  __typename: "User",
                  firstName: "Second",
                  ageRange: "999",
                  meta: {
                    ageRange: "123",
                    nullable: null,
                  },
                },
              ],
            },
          ],
        },
        {
          __root: {
            "": {
              f: "",
            },
            someUnion: {
              n: "",
              u: "union_Union",
            },
            someUnion_User: {
              f: "",
            },
            someUnion_User_ageRange: {
              e: "enum_Enum",
            },
            someUnion_User_meta: {
              f: "",
            },
            someUnion_User_meta_ageRange: {
              e: "enum_Enum",
            },
            someUnion_User_meta_nullable: {
              n: "",
            },
            friends: {
              n: "",
              u: "union_Union",
            },
            friends_User: {
              f: "",
            },
            friends_User_ageRange: {
              e: "enum_Enum",
            },
            friends_User_meta: {
              f: "",
            },
            friends_User_meta_ageRange: {
              e: "enum_Enum",
            },
            friends_User_meta_nullable: {
              n: "",
            },
            friends_Observer: {
              f: "",
            },
            friends_Observer_name: {
              n: "",
            },
            friends_Observer_ageRange: {
              e: "enum_Enum",
            },
            friends_Observer_meta: {
              f: "",
            },
            friends_Observer_meta_ageRange: {
              e: "enum_Enum",
            },
            friends_Observer_meta_nullable: {
              n: "",
            },
            friends_Observer_friends: {
              n: "",
              u: "union_Union",
            },
            friends_Observer_friends_User_ageRange: {
              e: "enum_Enum",
            },
            friends_Observer_friends_User: {
              f: "",
            },
            friends_Observer_friends_User_meta: {
              f: "",
            },
            friends_Observer_friends_User_meta_ageRange: {
              e: "enum_Enum",
            },
            friends_Observer_friends_User_meta_nullable: {
              n: "",
            },
          },
        },
        {
          enum_Enum: (v) => parseInt(v, 10),
          union_Union: (v) => [123, v],
        },
        undefined
      )
    ).toEqual({
      fragmentRefs: expect.any(Object),
      updatableFragmentRefs: expect.any(Object),
      someUnion: [
        123,
        {
          fragmentRefs: expect.any(Object),
          updatableFragmentRefs: expect.any(Object),
          __typename: "User",
          firstName: "First",
          ageRange: 123,
          meta: {
            fragmentRefs: expect.any(Object),
            updatableFragmentRefs: expect.any(Object),
            ageRange: 234,
            nullable: undefined,
          },
        },
      ],
      friends: [
        undefined,
        [
          123,
          {
            fragmentRefs: expect.any(Object),
            updatableFragmentRefs: expect.any(Object),
            __typename: "User",
            firstName: "First",
            ageRange: 123,
            meta: {
              fragmentRefs: expect.any(Object),
              updatableFragmentRefs: expect.any(Object),
              ageRange: 234,
              nullable: undefined,
            },
          },
        ],
        [
          123,
          {
            fragmentRefs: expect.any(Object),
            updatableFragmentRefs: expect.any(Object),
            __typename: "Observer",
            name: undefined,
            ageRange: 345,
            meta: {
              fragmentRefs: expect.any(Object),
              updatableFragmentRefs: expect.any(Object),
              ageRange: 456,
              nullable: undefined,
            },
            friends: [
              undefined,
              [
                123,
                {
                  fragmentRefs: expect.any(Object),
                  updatableFragmentRefs: expect.any(Object),
                  __typename: "User",
                  firstName: "Second",
                  ageRange: 999,
                  meta: {
                    fragmentRefs: expect.any(Object),
                    updatableFragmentRefs: expect.any(Object),
                    ageRange: 123,
                    nullable: undefined,
                  },
                },
              ],
            ],
          },
        ],
      ],
    });
  });

  it("handles recursive objects (input objects)", () => {
    expect(
      traverser(
        {
          someInput: {
            someEnum: "999",
            lat: null,
            meta: {
              someEnum: "888",
              nullable: null,
            },
            anotherInput: {
              meta: null,
              someEnum: "123",
              anotherInput: {
                someEnum: "234",
                anotherInput: null,
                meta: {
                  someEnum: "888",
                  nullable: null,
                },
              },
            },
          },
        },
        {
          AnotherInput: {
            someEnum: {
              e: "enum_Enum",
            },
            anotherInput: {
              n: "",
              r: "AnotherInput",
            },
            meta: {
              n: "",
            },
            meta_someEnum: {
              e: "enum_Enum",
            },
            meta_nullable: {
              n: "",
            },
          },
          SomeInput: {
            lat: {
              n: "",
            },
            someEnum: {
              e: "enum_Enum",
            },
            anotherInput: {
              r: "AnotherInput",
            },
            meta: {
              n: "",
            },
            meta_someEnum: {
              e: "enum_Enum",
            },
            meta_nullable: {
              n: "",
            },
          },
          __root: {
            someInput: {
              r: "SomeInput",
            },
          },
        },
        {
          enum_Enum: (v) => parseInt(v, 10),
        },
        undefined
      )
    ).toEqual({
      someInput: {
        someEnum: 999,
        lat: undefined,
        meta: {
          someEnum: 888,
          nullable: undefined,
        },
        anotherInput: {
          meta: undefined,
          someEnum: 123,
          anotherInput: {
            someEnum: 234,
            anotherInput: undefined,
            meta: {
              someEnum: 888,
              nullable: undefined,
            },
          },
        },
      },
    });
  });

  it("handles input unions", () => {
    expect(
      traverser(
        {
          location: {
            __$inputUnion: "byAddress",
            _0: {
              city: "City",
            },
          },
        },
        {
          location: { byLoc: { r: "byLoc" }, byAddress: { r: "byAddress" } },
          byAddress: {},
          byLoc: {},
          __root: { location: { r: "location" } },
        },
        {},
        undefined
      )
    ).toEqual({
      location: {
        byAddress: {
          city: "City",
        },
      },
    });
  });

  it("handles top level unions on fragments", () => {
    expect(
      traverser(
        {
          __typename: "User",
          name: "Name",
          onlineStatus: "Online",
        },
        {
          __root: {
            "": { u: "fragment" },
            User_onlineStatus: { n: "", e: "enum_OnlineStatus" },
          },
        },
        {
          fragment: (v) => [123, v],
          enum_OnlineStatus: (v) => "enum_OnlineStatus",
        },
        undefined
      )
    ).toEqual([
      123,
      {
        __typename: "User",
        name: "Name",
        onlineStatus: "enum_OnlineStatus",
      },
    ]);
  });

  it("handles nullable top level arrays", () => {
    expect(
      traverser(
        [
          {
            name: "Name",
          },
          null,
        ],

        { __root: { "": { na: "" } } },
        undefined
      )
    ).toEqual([
      {
        name: "Name",
      },
      undefined,
    ]);
  });

  test("regression - union members not converted properly via member path", () => {
    expect(
      traverser(
        {
          __typename: "RecurringCost",
          id: "UmVjdXJyaW5nQ29zdDoxNjI2Y2QwNC0yMmE0LTQ5MjktOWQ0MC1hYzdmYzBhNWVkZjY,",
          endDate: null,
          startDate: 1633046400000,
          active: true,
          cost: {
            __fragments: {
              CurrencyValueDisplayer_value: true,
            },
          },
          identifier: "Google Ads",
          sources: [
            {
              source: "google_search_engine_marketing",
            },
          ],
        },
        {
          __root: {
            RecurringCost_endDate: { n: "" },
            RecurringCost_cost: { f: "" },
            "": { u: "fragment" },
          },
        },
        {
          fragment: (v) => [123, v],
        },
        undefined,
        undefined
      )
    ).toEqual([
      123,
      {
        __typename: "RecurringCost",
        id: "UmVjdXJyaW5nQ29zdDoxNjI2Y2QwNC0yMmE0LTQ5MjktOWQ0MC1hYzdmYzBhNWVkZjY,",
        endDate: undefined,
        startDate: 1633046400000,
        active: true,
        cost: {
          fragmentRefs: expect.any(Object),
          updatableFragmentRefs: expect.any(Object),
          __fragments: {
            CurrencyValueDisplayer_value: true,
          },
        },
        identifier: "Google Ads",
        sources: [
          {
            source: "google_search_engine_marketing",
          },
        ],
      },
    ]);
  });

  describe("blocking traversal", () => {
    test("block", () => {
      expect(
        traverser(
          {
            input: {
              onlineStatus: "Idle",
              someJsonValue: {
                foo: null,
                bar: [["Boz", ["other text"]]],
                baz: "some string",
              },
              recursed: {
                someValue: "100",
                setOnlineStatus: {
                  onlineStatus: "Online",
                  someJsonValue: {
                    foo: null,
                    bar: [["Boz", ["other text"]]],
                    baz: "some string",
                  },
                  recursed: {
                    someValue: "100",
                  },
                },
              },
            },
          },
          {
            recursiveSetOnlineStatusInput: {
              someValue: { c: "TestsUtils.IntString" },
              setOnlineStatus: { r: "setOnlineStatusInput" },
            },
            setOnlineStatusInput: {
              someJsonValue: { b: "" },
              recursed: { r: "recursiveSetOnlineStatusInput" },
            },
            __root: { input: { r: "setOnlineStatusInput" } },
          },
          {
            "TestsUtils.IntString": (v) => parseInt(v),
          },
          undefined
        )
      ).toEqual({
        input: {
          onlineStatus: "Idle",
          someJsonValue: {
            foo: null,
            bar: [["Boz", ["other text"]]],
            baz: "some string",
          },
          recursed: {
            someValue: 100,
            setOnlineStatus: {
              onlineStatus: "Online",
              someJsonValue: {
                foo: null,
                bar: [["Boz", ["other text"]]],
                baz: "some string",
              },
              recursed: {
                someValue: 100,
              },
            },
          },
        },
      });
    });

    test("properly block", () => {
      const customScalar = {
        someProp: null,
      };

      const traversed = traverser(
        {
          someCustomScalarHolder: {
            someCustomScalar: customScalar,
            otherField: null,
            asArray: [customScalar],
          },
        },
        {
          __root: {
            someCustomScalarHolder_someCustomScalar: {
              c: "TestsUtils.SomeCustomScalar",
            },
            someCustomScalarHolder_asArray: {
              b: "a",
            },
          },
        },
        {
          "TestsUtils.SomeCustomScalar": () => customScalar,
        },
        undefined
      );

      expect(traversed).toEqual({
        someCustomScalarHolder: {
          someCustomScalar: customScalar,
          otherField: undefined,
          asArray: [customScalar],
        },
      });

      expect(traversed.someCustomScalarHolder.someCustomScalar).toBe(
        customScalar
      );
      expect(traversed.someCustomScalarHolder.asArray[0]).toBe(customScalar);
    });

    test("traversals can be blocked", () => {
      expect(
        traverser(
          {
            someJsonValue: { value: null },
            someJsonValueInArr: [null, { value: null }, null],
            someJsonValueAsArr: [null, { value: null }, null],
            someJsonValueAsArrInArr: [null, [{ value: null }, null], null],
          },
          {
            __root: {
              someJsonValue: {
                b: "",
              },
              someJsonValueInArr: {
                b: "a",
              },
              someJsonValueAsArr: {
                b: "",
              },
              someJsonValueAsArrInArr: {
                b: "a",
              },
            },
          },
          {},
          undefined,
          undefined
        )
      ).toEqual({
        someJsonValue: { value: null },
        someJsonValueInArr: [undefined, { value: null }, undefined],
        someJsonValueAsArr: [null, { value: null }, null],
        someJsonValueAsArrInArr: [
          undefined,
          [{ value: null }, null],
          undefined,
        ],
      });
    });
  });

  describe("regression - union not wrapped", () => {
    test("case 1", () => {
      expect(
        traverser(
          {
            __typename: "EphemeralForSalePropertySearch",
            localUnsavedPropertySearch: {
              __typename: "EphemeralForSalePropertySearch",
              __isPropertySearch: "EphemeralForSalePropertySearch",
              forSalePropertyTypes: [],
              isLocalUnsavedSearch: true,
              nodeId: "local-unsaved-search",
            },
          },
          {
            __root: {
              localUnsavedPropertySearch: {
                u: "rawResponse_localUnsavedPropertySearch",
              },
            },
          },
          {
            rawResponse_localUnsavedPropertySearch:
              function wrap_rawResponse_localUnsavedPropertySearch(v) {
                return v;
              },
          },
          null,
          undefined
        )
      ).toEqual({
        __typename: "EphemeralForSalePropertySearch",
        localUnsavedPropertySearch: {
          __typename: "EphemeralForSalePropertySearch",
          __isPropertySearch: "EphemeralForSalePropertySearch",
          forSalePropertyTypes: [],
          isLocalUnsavedSearch: true,
          nodeId: "local-unsaved-search",
        },
      });
    });

    test("case 2, nested union", () => {
      expect(
        traverser(
          {
            node: {
              __typename: "User",
              avatarUrl: undefined,
              firstName: "AnotherFirst",
              id: "user-1",
              memberOf: [
                {
                  __typename: "Group",
                  __isNode: "Group",
                  id: "group-1",
                  name: "Some Group",
                  topMember: {
                    __typename: "User",
                    __isNode: "User",
                    firstName: "Some User",
                    id: "user-2",
                  },
                },
              ],
              memberOfSingular: undefined,
            },
          },
          {
            __root: {
              node_memberOf_Group_topMember: {
                u: "rawResponse_node_memberOf_Group_topMember",
              },
              node_memberOfSingular: { u: "rawResponse_node_memberOfSingular" },
              node_memberOf: { u: "rawResponse_node_memberOf" },
            },
          },
          {
            rawResponse_node_memberOf_Group_topMember:
              function wrap_rawResponse_node_memberOf_Group_topMember(v) {
                return v;
              },
            rawResponse_node_memberOf: function wrap_rawResponse_node_memberOf(
              v
            ) {
              return v;
            },
            rawResponse_node_memberOfSingular:
              function wrap_rawResponse_node_memberOfSingular(v) {
                return v;
              },
          },
          null,
          undefined
        )
      ).toEqual({
        node: {
          __typename: "User",
          avatarUrl: null,
          firstName: "AnotherFirst",
          id: "user-1",
          memberOf: [
            {
              __typename: "Group",
              __isNode: "Group",
              id: "group-1",
              name: "Some Group",
              topMember: {
                __typename: "User",
                __isNode: "User",
                firstName: "Some User",
                id: "user-2",
              },
            },
          ],
          memberOfSingular: null,
        },
      });
    });
  });

  describe("multi scalar encoding", () => {
    expect(
      traverser(
        {
          os1s: [
            {
              a: "a",
              b: "b",
            }
          ],
          os2: {
            a: "a",
            c: "c",
          }
        },
          {
            __root: {
              os2:{c:"TestsUtils.ObjectScalar2"},
              os1s:{ca:"TestsUtils.ObjectScalar1"}
            },
          },
        {
          "TestsUtils.ObjectScalar1": _ => "serialized1",
          "TestsUtils.ObjectScalar2": _ => "serialized2",
        },
        undefined
      )
    ).toEqual({
      os1s: ["serialized1"],
      os2: "serialized2",
    });
  });
});
