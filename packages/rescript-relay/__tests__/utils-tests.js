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

  // `c` and `ca` are emitted identically for all four GraphQL array
  // nullability variants (`[T!]!` / `[T!]` / `[T]!` / `[T]`) — only
  // `found_in_array` (relay-typegen/src/rescript.rs) is encoded. The
  // cells below cover each wire-payload shape `traverse` may see.
  describe("custom scalar instructions (c, ca)", () => {
    const SCALAR = "TestsUtils.FakeScalar";
    // `parse` is shaped so an accidental `parse(null)` shows up in the
    // assertion as `"parsed:null"` rather than something innocuous.
    const parse = (v) => `parsed:${String(v)}`;
    const serialize = (v) => ({ serialized: v });
    const someNoneMarker = { BS_PRIVATE_NESTED_SOME_NONE: 0 };

    describe("c — single custom scalar, read (nullableValue: undefined)", () => {
      test("present value runs through `parse` and is the only sibling untouched", () => {
        expect(
          traverser(
            { x: "raw" },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ x: "parsed:raw" });
      });

      test("null wire value becomes `undefined` and `parse` is never called", () => {
        const spy = jest.fn(parse);
        expect(
          traverser(
            { x: null },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: spy },
            undefined
          )
        ).toEqual({ x: undefined });
        expect(spy).not.toHaveBeenCalled();
      });

      test("BS_PRIVATE_NESTED_SOME_NONE marker passes through unchanged", () => {
        const spy = jest.fn(parse);
        const out = traverser(
          { x: someNoneMarker },
          { __root: { x: { c: SCALAR } } },
          { [SCALAR]: spy },
          undefined
        );
        expect(out.x).toBe(someNoneMarker);
        expect(spy).not.toHaveBeenCalled();
      });

      test("c sibling with a null neighbour — null neighbour decodes to undefined", () => {
        expect(
          traverser(
            { x: "raw", y: null },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ x: "parsed:raw", y: undefined });
      });
    });

    describe("c — single custom scalar, write (nullableValue: null)", () => {
      test("present value runs through `serialize`", () => {
        expect(
          traverser(
            { x: 7 },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({ x: { serialized: 7 } });
      });

      test("null encodes to null and `serialize` is never called", () => {
        const spy = jest.fn(serialize);
        expect(
          traverser(
            { x: null },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: spy },
            null
          )
        ).toEqual({ x: null });
        expect(spy).not.toHaveBeenCalled();
      });

      test("c sibling followed by another c — both converters run", () => {
        const out = traverser(
          { a: 1, b: 2 },
          { __root: { a: { c: SCALAR }, b: { c: SCALAR } } },
          { [SCALAR]: serialize },
          null
        );
        expect(out).toEqual({
          a: { serialized: 1 },
          b: { serialized: 2 },
        });
      });
    });

    describe("ca — custom scalar array, read (nullableValue: undefined)", () => {
      test("[T!]! / [T!] — non-null elements, present array: parse runs per element", () => {
        expect(
          traverser(
            { xs: ["a", "b"] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ xs: ["parsed:a", "parsed:b"] });
      });

      test("[T!]! / [T]! — empty array stays empty, parse is never called", () => {
        const spy = jest.fn(parse);
        expect(
          traverser(
            { xs: [] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: spy },
            undefined
          )
        ).toEqual({ xs: [] });
        expect(spy).not.toHaveBeenCalled();
      });

      test("[T!] / [T] — array-level null decodes to undefined", () => {
        const spy = jest.fn(parse);
        expect(
          traverser(
            { xs: null },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: spy },
            undefined
          )
        ).toEqual({ xs: undefined });
        expect(spy).not.toHaveBeenCalled();
      });

      test("[T]! / [T] — array contains a null element: CURRENT BEHAVIOR calls parse(null)", () => {
        // Locks in current behavior. utils.js:109-113 maps `converter`
        // over every element with no per-element null check, so a wire
        // null reaches user code as `parse(null)`. A future fix should
        // produce `[parse("a"), undefined, parse("b")]` — out of scope
        // for this PR.
        expect(
          traverser(
            { xs: ["a", null, "b"] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ xs: ["parsed:a", "parsed:null", "parsed:b"] });
      });

      test("BS_PRIVATE_NESTED_SOME_NONE on a ca field passes through unchanged", () => {
        const spy = jest.fn(parse);
        const out = traverser(
          { xs: someNoneMarker },
          { __root: { xs: { ca: SCALAR } } },
          { [SCALAR]: spy },
          undefined
        );
        expect(out.xs).toBe(someNoneMarker);
        expect(spy).not.toHaveBeenCalled();
      });
    });

    describe("ca — custom scalar array, write (nullableValue: null)", () => {
      test("[T!]! / [T!] — present array: serialize runs per element", () => {
        expect(
          traverser(
            { xs: [10, 20] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          xs: [{ serialized: 10 }, { serialized: 20 }],
        });
      });

      test("[T!] / [T] — null array encodes to null, serialize never called", () => {
        const spy = jest.fn(serialize);
        expect(
          traverser(
            { xs: null },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: spy },
            null
          )
        ).toEqual({ xs: null });
        expect(spy).not.toHaveBeenCalled();
      });

      test("[T]! / [T] — array contains null element: CURRENT BEHAVIOR calls serialize(null)", () => {
        // Symmetric to the read-side cell of the same name. Out of
        // scope for this PR; correct output would be
        // `[serialize(10), null, serialize(30)]`.
        expect(
          traverser(
            { xs: [10, null, 30] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          xs: [
            { serialized: 10 },
            { serialized: null },
            { serialized: 30 },
          ],
        });
      });
    });

    describe("regression #631 — `ca` followed by null sibling", () => {
      test("read — null sibling decodes to undefined", () => {
        expect(
          traverser(
            { xs: ["a"], q: null },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ xs: ["parsed:a"], q: undefined });
      });

      test("write — null sibling encodes to null", () => {
        expect(
          traverser(
            { xs: [1], q: null },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({ xs: [{ serialized: 1 }], q: null });
      });
    });

    describe("regression #582 — `ca` followed by another `c`", () => {
      test("write — both converters run", () => {
        expect(
          traverser(
            { xs: [1], y: 2 },
            { __root: { xs: { ca: SCALAR }, y: { c: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          xs: [{ serialized: 1 }],
          y: { serialized: 2 },
        });
      });

      test("read — both converters run", () => {
        expect(
          traverser(
            { xs: ["a"], y: "b" },
            { __root: { xs: { ca: SCALAR }, y: { c: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({
          xs: ["parsed:a"],
          y: "parsed:b",
        });
      });
    });

    describe("regression #407 — single `c` whose underlying type is an array", () => {
      // GraphQL type is a single scalar but the ReScript representation
      // is an array (e.g. `Number = array<int>`). Hits the
      // `shouldConvertCustomField && Array.isArray(...)` branch at
      // utils.js:134-138 — not `ca`.
      test("read — converter receives the whole array as one argument, traversal continues", () => {
        const wholeArrayConverter = (arr) =>
          Array.isArray(arr) ? `arr:${arr.length}` : `not-arr:${String(arr)}`;
        expect(
          traverser(
            { x: [1, 2, 3], q: null },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: wholeArrayConverter },
            undefined
          )
        ).toEqual({ x: "arr:3", q: undefined });
      });

      test("write — converter receives the whole array as one argument, traversal continues", () => {
        const wholeArrayConverter = (arr) =>
          Array.isArray(arr) ? arr.reduce((a, b) => a + b, 0) : -1;
        expect(
          traverser(
            { x: [1, 2, 3], q: null },
            { __root: { x: { c: SCALAR } } },
            { [SCALAR]: wholeArrayConverter },
            null
          )
        ).toEqual({ x: 6, q: null });
      });
    });

    describe("sequencing — `ca` and other fields in the same selection set", () => {
      test("two `ca` fields in a row — both arrays are converted", () => {
        expect(
          traverser(
            { as: [1, 2], bs: [10, 20] },
            { __root: { as: { ca: SCALAR }, bs: { ca: SCALAR } } },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          as: [{ serialized: 1 }, { serialized: 2 }],
          bs: [{ serialized: 10 }, { serialized: 20 }],
        });
      });

      test("`ca` followed by a nested object whose fields need conversion — recursive descent still runs", () => {
        expect(
          traverser(
            { xs: [1], inner: { y: 2 } },
            {
              __root: {
                xs: { ca: SCALAR },
                inner_y: { c: SCALAR },
              },
            },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          xs: [{ serialized: 1 }],
          inner: { y: { serialized: 2 } },
        });
      });

      test("null sibling BEFORE `ca` — positive control, no bug to trigger here", () => {
        // Documents that the bug fixed by this PR was order-sensitive:
        // it only fired when `ca` came BEFORE other fields, because the
        // early-`return` skipped the rest of the loop. With the null
        // sibling first, it's coerced normally and `ca` then runs.
        expect(
          traverser(
            { q: null, xs: ["a"] },
            { __root: { xs: { ca: SCALAR } } },
            { [SCALAR]: parse },
            undefined
          )
        ).toEqual({ q: undefined, xs: ["parsed:a"] });
      });
    });

    describe("`ca` inside a nested input object", () => {
      test("ca field followed by plain fields inside an `r` record stays intact", () => {
        expect(
          traverser(
            {
              input: {
                ids: [1, 2, 3],
                take: 1,
                skip: 0,
              },
            },
            {
              __root: { input: { r: "searchInput" } },
              searchInput: { ids: { ca: SCALAR } },
            },
            { [SCALAR]: serialize },
            null
          )
        ).toEqual({
          input: {
            ids: [{ serialized: 1 }, { serialized: 2 }, { serialized: 3 }],
            take: 1,
            skip: 0,
          },
        });
      });
    });
  });
});
