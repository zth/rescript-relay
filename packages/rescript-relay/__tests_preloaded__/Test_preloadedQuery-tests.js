require("@testing-library/jest-dom/extend-expect");
const nock = require("nock");
const t = require("@testing-library/react");
const React = require("react");

const { test_preloadedQuery } = require("./Test_preloadedQuery.bs");

nock(`http://graphql`)
  .persist()
  .post("/")
  .reply((_uri, data, cb) => {
    const { id, variables } = data;
    if (id == null) {
      throw new Error("Got no ID.");
    }

    expect(variables).toEqual({
      status: "Online",
      __relay_internal__pv__ProvidedVariablesBool: true,
      __relay_internal__pv__ProvidedVariablesInputC: {
        intStr: "123",
        recursiveC: {
          intStr: "234",
        },
      },
      __relay_internal__pv__ProvidedVariablesInputCArr: [
        {
          intStr: "123",
        },
      ],
      __relay_internal__pv__ProvidedVariablesIntStr: "456",
    });

    cb(null, [
      200,
      {
        data: {
          loggedInUser: {
            id: "<id>",
            someRandomArgField: "Random",
          },
          users: {
            edges: [
              {
                node: { id: "<id>", firstName: "First", onlineStatus: "Idle" },
              },
            ],
          },
        },
      },
    ]);
  });

describe("Preloaded Query", () => {
  test("basic preloaded queries work", async () => {
    expect.assertions(1);
    t.render(test_preloadedQuery());
    await t.screen.findByText("Preloaded First is idle");
  });
});
