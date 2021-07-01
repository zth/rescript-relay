import { program } from "commander";
import config from "relay-config";
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
  prettify,
  processReanalyzeOutput,
  removeUnusedFieldsFromFragment,
  restoreOperationPadding,
} from "./cliUtils";

const exists = fs.statSync(
  path.resolve(path.join(process.cwd(), "relay.config.js")),
  { throwIfNoEntry: false }
);

if (exists == null) {
  console.error(
    "relay.config.js must exist in the current working directory this script runs in."
  );

  process.exit(1);
}

const relayConfig = config.loadConfig();

if (!relayConfig) {
  console.error(
    "Could not find relay.config.js. You must configure Relay through relay.config.js for RescriptRelay to work."
  );

  process.exit(1);
}

if (!relayConfig.artifactDirectory) {
  console.error(
    "RescriptRelay requires you to define 'artifactDirectory' (for outputing generated files in a single directory) in your relay.config.js. Please define it and re-run this command."
  );
  process.exit(1);
}

program.version("0.1.0");

program
  .command("remove-unused-fields")
  .description(
    "Remove unused GraphQL selections in fragments in current project."
  )
  .action(() => {
    const spinner = ora("Analyzing ReScript project").start();

    const artifactDirectoryLocation = path.resolve(
      path.join(process.cwd(), relayConfig.artifactDirectory!)
    );

    const sourceLocExtractor = new RegExp(
      /(?<=\/\* @sourceLoc )[A-Za-z_.0-9]+(?= \*\/)/g
    );

    const p = cp.exec(`npx reanalyze -dce`);

    if (p.stdout == null) {
      console.error("Something went wrong.");
      process.exit(1);
    }

    let data = "";

    p.stdout.on("data", (d) => {
      data += d;
    });

    p.on("close", async () => {
      spinner.text = "Analyzing GraphQL usage";
      const processed = processReanalyzeOutput(data);

      const withSourceLocation: IFragmentRepresentationWithSourceLocation[] =
        [];

      spinner.text = "Scanning fragment files";

      await Promise.all(
        Object.entries(processed).map(async ([fileLocation, data]) => {
          const absoluteFilePath = path.resolve(
            path.join(artifactDirectoryLocation, fileLocation)
          );

          try {
            spinner.text = `Scanning file ${absoluteFilePath}`;
            const fileContents = await fs.promises.readFile(absoluteFilePath, {
              encoding: "utf-8",
            });

            const sourceLocation = fileContents.match(sourceLocExtractor)?.[0];

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

      spinner.text = `Findings files to modify`;

      const sourcesToFind = withSourceLocation.map((v) => ({
        path: `**/${v.sourceLocation}`,
        fragmentName: v.fragmentName,
      }));

      const files = await glob(
        sourcesToFind.map((s) => s.path),
        { absolute: true }
      );

      const filesWithInfo = files.map((absoluteFilePath) => {
        const entry = withSourceLocation.find((item) =>
          absoluteFilePath.endsWith(item.sourceLocation)
        );

        if (entry != null) {
          return {
            absoluteFilePath,
            ...entry,
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

            const graphqlTags = extractGraphQLSourceFromReScript(fileContents);

            let parsedTag: DocumentNode | null = null;
            let targetTag: GraphQLSourceFromTag | null = null;

            for (const tag of graphqlTags) {
              const parsed = parse(tag.content);

              if (
                parsed.definitions[0]?.kind === "FragmentDefinition" &&
                parsed.definitions[0].name.value === fileWithInfo.fragmentName
              ) {
                parsedTag = parsed;
                targetTag = tag;
                break;
              }
            }

            if (parsedTag == null || targetTag == null) return;
            const targetDef = parsedTag.definitions[0];
            if (targetDef == null || targetDef.kind !== "FragmentDefinition") {
              return;
            }

            const processedOperation = removeUnusedFieldsFromFragment({
              definition: targetDef,
              unusedFieldPaths: fileWithInfo.unusedFieldPaths,
            });

            const operationAsText =
              processedOperation == null
                ? "# This module is unused and can be removed"
                : print(processedOperation);

            const newContent = restoreOperationPadding(
              prettify(operationAsText),
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

      spinner.succeed("Done!");
    });
  });

program.parse(process.argv);
