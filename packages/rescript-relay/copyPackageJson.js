#!/usr/bin/env node
const tagName = process.argv[3];
const fs = require("fs");
const path = require("path");

const pkgJsonRaw = fs.readFileSync(
  path.resolve(path.join(__dirname, "./package.json")),
  "utf-8"
);

const pkgJson = JSON.parse(pkgJsonRaw);

// Bypass forcing package name and version for the beta track.
if (tagName && tagName !== "beta") {
  const commit = require("child_process")
    .execSync("git rev-parse HEAD")
    .toString()
    .trim()
    .slice(0, 8);

  pkgJson.version = `0.0.0-${tagName}-${commit}`;
}

fs.writeFileSync(
  path.resolve(path.join(process.argv[2], "package.json")),
  JSON.stringify(pkgJson, null, 2)
);
