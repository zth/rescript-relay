import { Command } from "commander";
import ora from "ora";
import path from "path";
import fs from "fs";

export const addInitCommand = (program: Command) => {
  program
    .command("init")
    .description("Set up RescriptRelay in this directory.")
    .action(async () => {
      // Being able to run this command means the main package is installed, so we
      // don't need to care about that.
      const spinner = ora("Setting up RescriptRelay...").start();

      const packageJsonRaw = fs.readFileSync(
        path.resolve(process.cwd(), "package.json"),
        "utf8"
      );

      let packageJsonParsed: Record<string, unknown> = {};

      try {
        packageJsonParsed = JSON.parse(packageJsonRaw);
      } catch (e) {
        console.error(e);
        spinner.fail(
          "Could not load package.json. This command needs to run in the same directory as package.json is located."
        );
        return;
      }

      /**
       * Install correct Relay versions
       * Check React version
       * Create relay.config.js
       * Create artifact directory
       */

      spinner.succeed("Done!");
    });
};
