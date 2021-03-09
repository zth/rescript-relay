import { readFileSync } from "fs";
import { Source } from "graphql";
import { Schema } from "relay-compiler";

const create = require("relay-compiler").Schema.create;

const generateSchema = (path: string): Schema =>
  create(new Source(readFileSync(path, "utf8")));

export default generateSchema;
