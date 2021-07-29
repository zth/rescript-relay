#!/usr/bin/env node
import { program } from "commander";
import fs from "fs";
import path from "path";
import cp from "child_process";
import glob from "fast-glob";
import ora from "ora";
import { DocumentNode, parse, print } from "graphql";
import {
  extractGraphQLSourceFromReScript,
  GraphQLSourceFromTag,
  IFragmentRepresentationWithSourceLocation,
  maybePluralize,
  prettify,
  processReanalyzeOutput,
  removeUnusedFieldsFromOperation,
  restoreOperationPadding,
} from "./cliUtils";
import { formatOperationsInDocument } from "./formatUtils";
import {
  findAllSourceFilesFromGeneratedFiles,
  findSourceFiles,
  getAllGeneratedFiles,
  getRelayArtifactDirectoryLocation,
  getSrcCwd,
  loadRelayConfig,
  sourceLocExtractor,
} from "./fileUtils";

program.version("0.1.0");

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

program
  .command("debug")
  .description("Prints debug information for the CLI.")
  .action(async () => {
    const relayConfig = loadRelayConfig();
    const artifactDirectoryLocation =
      getRelayArtifactDirectoryLocation(relayConfig);

    console.log(`Artifact directory location: ${artifactDirectoryLocation}\n`);

    console.log("Getting all generated files...\n");
    const allGeneratedFiles = await getAllGeneratedFiles(
      artifactDirectoryLocation
    );
    console.log(
      `Number of generated files found in artifact directory: ${allGeneratedFiles.length}\n`
    );

    console.log("Looking up source files\n");

    const files = await findAllSourceFilesFromGeneratedFiles(allGeneratedFiles);

    console.log(
      `Found ${files.length} source locations with explicit definitions.\n`
    );

    console.log("Looking up source files..\n");

    const sourceFiles = await findSourceFiles(files, relayConfig.src);

    console.log(
      `Found ${
        sourceFiles.length
      } actual source files, when looking in ${getSrcCwd(relayConfig.src)}.\n`
    );

    console.log("Done!");
  });

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

program
  .command("remove-unused-fields")
  .option("--verbose", "Verbose mode")
  .option("--debug", "Debug mode")
  .option(
    "--ci",
    "CI mode: Exit if unused fields exist, but don't remove them."
  )
  .description(
    "Remove unused GraphQL selections in fragments in current project."
  )
  .action(
    ({
      ci,
      verbose,
      debug,
    }: {
      ci?: boolean;
      verbose?: boolean;
      debug?: boolean;
    }) => {
      const relayConfig = loadRelayConfig();
      const artifactDirectoryLocation =
        getRelayArtifactDirectoryLocation(relayConfig);

      const spinner = ora("Analyzing ReScript project").start();

      const p = cp.spawn("npx", ["reanalyze", "-dce"]);

      if (p.stdout == null) {
        console.error("Something went wrong.");
        process.exit(1);
      }

      let data = "";

      p.stdout.on("data", (d) => {
        data += d;
      });

      p.stderr?.on("data", (e) => {
        if (e.includes("End_of_file")) {
          spinner.fail(
            `Something went wrong trying to analyze the ReScript project. Try cleaning your ReScript project and rebuilding it from scratch before trying again.`
          );
        } else {
          spinner.fail(
            `Something went wrong trying to analyze the ReScript project.`
          );
        }
        if (debug) {
          console.error(e);
        }
        process.exit(1);
      });

      p.on("close", async () => {
        spinner.text = "Analyzing GraphQL usage";
        const processed = processReanalyzeOutput(data);

        if (debug) {
          console.log(
            `Found ${maybePluralize(
              "file",
              Object.keys(processed).length
            )} with potentially missing fields.`
          );
        }

        const withSourceLocation: IFragmentRepresentationWithSourceLocation[] =
          [];

        spinner.text = "Scanning fragment files";

        if (debug) {
          console.log(
            `Extracing source locations for ${maybePluralize(
              "files",
              Object.keys(processed).length
            )}.`
          );
        }

        await Promise.all(
          Object.entries(processed).map(async ([fileLocation, data]) => {
            const absoluteFilePath = path.resolve(
              path.join(artifactDirectoryLocation, fileLocation)
            );

            try {
              const fileContents = await fs.promises.readFile(
                absoluteFilePath,
                {
                  encoding: "utf-8",
                }
              );

              const sourceLocation =
                fileContents.match(sourceLocExtractor)?.[0];

              if (sourceLocation != null) {
                withSourceLocation.push({
                  ...data,
                  sourceLocation,
                });
              }
            } catch (e) {
              console.error(e);
            }
          })
        );

        if (verbose && withSourceLocation.length > 0) {
          console.log(
            `\n\n------\nUnused fields: \n`,
            withSourceLocation
              .map(
                (f) =>
                  `${f.type === "fragment" ? "Fragment" : "Query"} "${
                    f.graphqlName
                  }" in ${f.sourceLocation}: \n  ${f.unusedFieldPaths.join(
                    "\n  "
                  )}`
              )
              .join("\n\n"),
            `\n------\n\n`
          );
        }

        if (ci) {
          if (withSourceLocation.length === 0) {
            spinner.succeed("No unused fields found.");
            process.exit(0);
          } else {
            spinner.fail(
              `Found ${withSourceLocation.length} file(s) with unused fields.`
            );
            process.exit(1);
          }
        }

        spinner.text = `Findings files to modify`;

        const sourcesToFind = withSourceLocation.map((v) => ({
          path: `**/${v.sourceLocation}`,
          graphqlName: v.graphqlName,
        }));

        const files = await glob(
          sourcesToFind.map((s) => s.path),
          { absolute: true, ignore: ["node_modules/**/*"] }
        );

        const filesWithInfo = files.map((absoluteFilePath) => {
          const entry = withSourceLocation.find((item) =>
            absoluteFilePath.endsWith(item.sourceLocation)
          );

          if (entry != null) {
            return {
              ...entry,
              absoluteFilePath,
            };
          }
        });

        spinner.text = `Removing unused fields`;

        await Promise.all(
          filesWithInfo.map(async (fileWithInfo) => {
            if (fileWithInfo == null) return;

            try {
              const fileContents = await fs.promises.readFile(
                fileWithInfo.absoluteFilePath,
                {
                  encoding: "utf-8",
                }
              );

              const graphqlTags =
                extractGraphQLSourceFromReScript(fileContents);

              let parsedTag: DocumentNode | null = null;
              let targetTag: GraphQLSourceFromTag | null = null;

              for (const tag of graphqlTags) {
                const parsed = parse(tag.content);

                const definition = parsed.definitions[0];

                if (definition == null) {
                  continue;
                }

                if (
                  (definition.kind === "OperationDefinition" ||
                    definition.kind === "FragmentDefinition") &&
                  definition.name?.value === fileWithInfo.graphqlName
                ) {
                  parsedTag = parsed;
                  targetTag = tag;
                  break;
                }
              }

              if (parsedTag == null || targetTag == null) return;
              const targetDef = parsedTag.definitions[0];
              if (
                targetDef == null ||
                !(
                  targetDef.kind === "FragmentDefinition" ||
                  targetDef.kind === "OperationDefinition"
                )
              ) {
                return;
              }

              const processedOperation = removeUnusedFieldsFromOperation({
                definition: targetDef,
                unusedFieldPaths: fileWithInfo.unusedFieldPaths,
              });

              const newContent =
                processedOperation == null
                  ? "# This module is unused and can be removed"
                  : restoreOperationPadding(
                      prettify(print(processedOperation)),
                      targetTag.content
                    );

              await fs.promises.writeFile(
                fileWithInfo.absoluteFilePath,
                `${fileContents.slice(
                  0,
                  targetTag.start
                )}${newContent}${fileContents.slice(targetTag.end)}`
              );
            } catch (e) {
              console.error(e);
            }
          })
        );

        const numFieldsRemoved = filesWithInfo.reduce((acc, curr) => {
          return acc + (curr?.unusedFieldPaths.length ?? 0);
        }, 0);

        if (numFieldsRemoved === 0) {
          spinner.succeed("Done! No unused fields found.");
        } else {
          spinner.succeed(
            `Done! Removed ${maybePluralize(
              "field",
              numFieldsRemoved
            )} from ${maybePluralize("file", filesWithInfo.length)}.`
          );
        }
      });
    }
  );

program.parse(process.argv);
