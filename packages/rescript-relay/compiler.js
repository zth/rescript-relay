#!/usr/bin/env node
"use strict";

var spawn = require("child_process").spawn;
var path = require("path");

var input = process.argv.slice(2);

spawn(path.join(__dirname, "rescript-relay-compiler.exe"), input, {
  stdio: "inherit",
}).on("exit", process.exit);
