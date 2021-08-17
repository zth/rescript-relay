#!/usr/bin/env node
import { program } from "commander";
import { addFormatGraphQLCommands } from "./commands/formatGraphQLCommand";
import { addDebugCommand } from "./commands/debugCommand";
import { addRemoveUnusedFieldsCommand } from "./commands/removeUnusedFieldsCommand";

program.version("0.1.0");

addFormatGraphQLCommands(program);
addDebugCommand(program);
addRemoveUnusedFieldsCommand(program);
// addInitCommand(program);

program.parse(process.argv);
