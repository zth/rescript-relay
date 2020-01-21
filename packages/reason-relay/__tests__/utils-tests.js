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
            nestedObjects: [{ someProp: null, otherProp: "Lars" }, null]
          },
          otherProp: null
        },
        {
          "": {
            f: ""
          },
          otherProp: {
            n: ""
          },
          me: {
            n: "",
            f: ""
          },
          me_age: {
            n: ""
          },
          me_nicknames: {
            n: ""
          },
          me_nestedObjects: {
            n: "",
            f: ""
          },
          me_nestedObjects_someProp: {
            n: ""
          }
        },
        {},
        undefined
      )
    ).toEqual({
      getFragmentRefs: expect.any(Function),
      me: {
        getFragmentRefs: expect.any(Function),
        name: "Name",
        age: undefined,
        nicknames: [undefined, "SomeName"],
        nestedObjects: [
          {
            someProp: undefined,
            otherProp: "Lars",
            getFragmentRefs: expect.any(Function)
          },
          undefined
        ]
      },
      otherProp: undefined
    });
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
            nestedObjects: [{ someProp: null, otherProp: "345" }, null]
          }
        },
        {
          ageRange: {
            e: "enum_Enum"
          },
          me_ageRange: {
            n: "",
            e: "enum_Enum"
          },
          me_ageRanges: {
            n: "",
            e: "enum_Enum"
          },
          me_nestedObjects: {
            n: ""
          },
          me_nestedObjects_someProp: {
            n: ""
          },
          me_nestedObjects_otherProp: {
            n: "",
            e: "enum_Enum"
          }
        },
        {
          enum_Enum: v => parseInt(v, 10)
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
            otherProp: 345
          },
          undefined
        ]
      },
      otherProp: undefined
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
              nullable: null
            }
          },
          friends: [
            null,
            {
              __typename: "User",
              firstName: "First",
              ageRange: "123",
              meta: {
                ageRange: "234",
                nullable: null
              }
            },
            {
              __typename: "Observer",
              name: null,
              ageRange: "345",
              meta: {
                ageRange: "456",
                nullable: null
              },
              friends: [
                null,
                {
                  __typename: "User",
                  firstName: "Second",
                  ageRange: "999",
                  meta: {
                    ageRange: "123",
                    nullable: null
                  }
                }
              ]
            }
          ]
        },
        {
          "": {
            f: ""
          },
          someUnion: {
            n: "",
            u: "union_Union"
          },
          someUnion_user: {
            f: ""
          },
          someUnion_user_ageRange: {
            e: "enum_Enum"
          },
          someUnion_user_meta: {
            f: ""
          },
          someUnion_user_meta_ageRange: {
            e: "enum_Enum"
          },
          someUnion_user_meta_nullable: {
            n: ""
          },
          friends: {
            n: "",
            u: "union_Union"
          },
          friends_user: {
            f: ""
          },
          friends_user_ageRange: {
            e: "enum_Enum"
          },
          friends_user_meta: {
            f: ""
          },
          friends_user_meta_ageRange: {
            e: "enum_Enum"
          },
          friends_user_meta_nullable: {
            n: ""
          },
          friends_observer: {
            f: ""
          },
          friends_observer_name: {
            n: ""
          },
          friends_observer_ageRange: {
            e: "enum_Enum"
          },
          friends_observer_meta: {
            f: ""
          },
          friends_observer_meta_ageRange: {
            e: "enum_Enum"
          },
          friends_observer_meta_nullable: {
            n: ""
          },
          friends_observer_friends: {
            n: "",
            u: "union_Union"
          },
          friends_observer_friends_user_ageRange: {
            e: "enum_Enum"
          },
          friends_observer_friends_user: {
            f: ""
          },
          friends_observer_friends_user_meta: {
            f: ""
          },
          friends_observer_friends_user_meta_ageRange: {
            e: "enum_Enum"
          },
          friends_observer_friends_user_meta_nullable: {
            n: ""
          }
        },
        {
          enum_Enum: v => parseInt(v, 10),
          union_Union: v => [123, v]
        },
        undefined
      )
    ).toEqual({
      getFragmentRefs: expect.any(Function),
      someUnion: [
        123,
        {
          getFragmentRefs: expect.any(Function),
          __typename: "User",
          firstName: "First",
          ageRange: 123,
          meta: {
            getFragmentRefs: expect.any(Function),
            ageRange: 234,
            nullable: undefined
          }
        }
      ],
      friends: [
        undefined,
        [
          123,
          {
            getFragmentRefs: expect.any(Function),
            __typename: "User",
            firstName: "First",
            ageRange: 123,
            meta: {
              getFragmentRefs: expect.any(Function),
              ageRange: 234,
              nullable: undefined
            }
          }
        ],
        [
          123,
          {
            getFragmentRefs: expect.any(Function),
            __typename: "Observer",
            name: undefined,
            ageRange: 345,
            meta: {
              getFragmentRefs: expect.any(Function),
              ageRange: 456,
              nullable: undefined
            },
            friends: [
              undefined,
              [
                123,
                {
                  getFragmentRefs: expect.any(Function),
                  __typename: "User",
                  firstName: "Second",
                  ageRange: 999,
                  meta: {
                    getFragmentRefs: expect.any(Function),
                    ageRange: 123,
                    nullable: undefined
                  }
                }
              ]
            ]
          }
        ]
      ]
    });
  });
});
