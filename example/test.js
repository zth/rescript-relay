const fs = require("fs");
const path = require("path");
const cp = require("child_process");

const fragmentNameRegexp = new RegExp(
  /(?<=__generated__\/)[A-Za-z_]+(?=_graphql\.res)/g
);
const fieldPathRegexp = new RegExp(/(?<=Types\.fragment_)[A-Za-z_.]+(?= )/g);

const p = cp.exec(
  `npx reanalyze -dce -suppress src -unsuppress src/__generated__`
);

let data = "";

p.stdout.on("data", (d) => {
  data += d;
});

p.on("close", () => {
  const processed = data
    .split(/\n\n/g)
    .filter((s) => s.includes("Types.fragment_"))
    .reduce((acc, curr) => {
      const fragmentName = curr.match(fragmentNameRegexp);
      const fieldPath = curr.match(fieldPathRegexp);

      acc[fragmentName] = acc[fragmentName] || [];
      acc[fragmentName].push(fieldPath);

      return acc;
    }, {});

  console.log(processed);
});
