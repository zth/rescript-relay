import { Command } from "commander";
import ora from "ora";
import path from "path";
import fs from "fs";
import { maybePluralize } from "../cliUtils";
import {
  findAllSourceFilesFromGeneratedFiles,
  findSourceFiles,
  getAllGeneratedFiles,
  getRelayArtifactDirectoryLocation,
  loadRelayConfig,
} from "../fileUtils";
import { formatOperationsInDocument } from "../formatUtils";

export const addFormatGraphQLCommands = (program: Command) => {
  program
    .command("format-all-graphql")
    .description("Format all GraphQL operations in project.")
    .action(async () => {
      const relayConfig = loadRelayConfig();
      const artifactDirectoryLocation =
        getRelayArtifactDirectoryLocation(relayConfig);

      const spinner = ora("Findings files to format").start();

      const allGeneratedFiles = await getAllGeneratedFiles(
        artifactDirectoryLocation
      );

      const sourcesToFind = await findAllSourceFilesFromGeneratedFiles(
        allGeneratedFiles,
        spinner
      );

      spinner.text = `Searching for ${maybePluralize(
        "source file",
        sourcesToFind.length
      )}.`;

      const files = await findSourceFiles(sourcesToFind, relayConfig.src);

      const formatSuccesses = await Promise.all(
        files.map(async (filePath) => {
          spinner.text = `Formatting "${path.basename(filePath)}".`;
          const fileContents = await fs.promises.readFile(filePath, {
            encoding: "utf-8",
          });

          const formatted = formatOperationsInDocument(fileContents);

          if (fileContents !== formatted) {
            await fs.promises.writeFile(filePath, formatted);
          }

          return fileContents !== formatted;
        })
      );

      const numberOfFilesFormatted = formatSuccesses.filter(
        (status) => status === true
      ).length;

      if (numberOfFilesFormatted === 0) {
        spinner.succeed(
          `Done! None of ${maybePluralize(
            "scanned file",
            files.length
          )} needed formatting.`
        );
      } else {
        spinner.succeed(
          `Done! Formatted ${maybePluralize(
            "file",
            numberOfFilesFormatted
          )} of ${maybePluralize("scanned file", files.length)}.`
        );
      }
    });

  program
    .command("format-single-graphql")
    .description("Format GraphQL operations in single file.")
    .argument("<file>", "Path to file to format. Must be absolute.")
    .action(async (file) => {
      const spinner = ora("Formatting file..").start();

      const exists = await fs.promises.stat(file, { throwIfNoEntry: false });

      if (exists == null) {
        spinner.fail("File does not exist.");
        process.exit(1);
      }

      try {
        const fileContents = await fs.promises.readFile(file, {
          encoding: "utf-8",
        });

        const formatted = formatOperationsInDocument(fileContents);

        if (fileContents !== formatted) {
          await fs.promises.writeFile(file, formatted);
          spinner.succeed("Successfully formatted file.");
        } else {
          spinner.succeed("File already formatted.");
        }
      } catch {
        spinner.fail("Could not format file.");
        process.exit(1);
      }
    });
};
