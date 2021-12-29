import { Command } from "commander";
import ora from "ora";
import path from "path";
import cp from "child_process";
import fs from "fs";
import {
  DocumentNode,
  FragmentDefinitionNode,
  OperationDefinitionNode,
  parse,
  print,
} from "graphql";
import {
  processReanalyzeOutput,
  maybePluralize,
  IFragmentRepresentationWithSourceLocation,
  extractGraphQLSourceFromReScript,
  GraphQLSourceFromTag,
  removeUnusedFieldsFromOperation,
  restoreOperationPadding,
  prettify,
} from "../cliUtils";
import {
  loadRelayConfig,
  getRelayArtifactDirectoryLocation,
  sourceLocExtractor,
  findSourceFiles,
} from "../fileUtils";

export const addRemoveUnusedFieldsCommand = (program: Command) => {
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
                artifactDirectoryLocation,
                fileLocation
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

          spinner.text = `Findings files`;

          const sourcesToFind = withSourceLocation.map((v) => ({
            path: v.sourceLocation,
            graphqlName: v.graphqlName,
          }));

          const files = await findSourceFiles(
            sourcesToFind.map((s) => s.path),
            relayConfig.src
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

          spinner.text = `Analyzing found files`;

          const allRealFilesWithMissingFields: {
            absoluteFilePath: string;
            sourceLocation: string;
            type: "fragment" | "query";
            graphqlName: string;
            unusedFieldPaths: string[];
            targetDef: OperationDefinitionNode | FragmentDefinitionNode;
            fileContents: string;
            targetTag: GraphQLSourceFromTag;
          }[] = [];

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

                allRealFilesWithMissingFields.push({
                  targetDef,
                  fileContents,
                  targetTag,
                  ...fileWithInfo,
                });
              } catch (e) {
                console.error(e);
              }
            })
          );

          if (verbose && withSourceLocation.length > 0) {
            console.log(
              `\n\n------\nUnused fields: \n`,
              allRealFilesWithMissingFields
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
            if (allRealFilesWithMissingFields.length === 0) {
              spinner.succeed("No unused fields found.");
              process.exit(0);
            } else {
              spinner.fail(
                `Found ${allRealFilesWithMissingFields.length} file(s) with unused fields.`
              );
              process.exit(1);
            }
          }

          spinner.text = `Removing unused fields`;

          await Promise.all(
            allRealFilesWithMissingFields.map(
              async ({
                targetDef,
                unusedFieldPaths,
                targetTag,
                absoluteFilePath,
                fileContents,
              }) => {
                const processedOperation = removeUnusedFieldsFromOperation({
                  definition: targetDef,
                  unusedFieldPaths: unusedFieldPaths,
                });

                const newContent =
                  processedOperation == null
                    ? "# This module is unused and can be removed"
                    : restoreOperationPadding(
                        prettify(print(processedOperation)),
                        targetTag.content
                      );

                await fs.promises.writeFile(
                  absoluteFilePath,
                  `${fileContents.slice(
                    0,
                    targetTag.start
                  )}${newContent}${fileContents.slice(targetTag.end)}`
                );
              }
            )
          );

          const numFieldsRemoved = allRealFilesWithMissingFields.reduce(
            (acc, curr) => {
              return acc + (curr?.unusedFieldPaths.length ?? 0);
            },
            0
          );

          if (numFieldsRemoved === 0) {
            spinner.succeed("Done! No unused fields found.");
          } else {
            spinner.succeed(
              `Done! Removed ${maybePluralize(
                "field",
                numFieldsRemoved
              )} from ${maybePluralize(
                "file",
                allRealFilesWithMissingFields.length
              )}.`
            );
          }
        });
      }
    );
};
