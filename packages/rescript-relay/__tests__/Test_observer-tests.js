require("@testing-library/jest-dom/extend-expect");
const t = require("@testing-library/react");
const React = require("react");

const { test_observer } = require("./Test_observer.bs");

describe("Observer", () => {
  it("errors properly", async () => {
    t.render(test_observer());
    await t.screen.findByText("Failed");
  });
});
