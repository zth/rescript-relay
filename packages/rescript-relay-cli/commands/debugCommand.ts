import { Command } from "commander";
import {
  loadRelayConfig,
  getRelayArtifactDirectoryLocation,
  getAllGeneratedFiles,
  findAllSourceFilesFromGeneratedFiles,
  findSourceFiles,
  getSrcCwd,
} from "../fileUtils";

export const addDebugCommand = (program: Command) => {
  program
    .command("debug")
    .description("Prints debug information for the CLI.")
    .action(async () => {
      const relayConfig = loadRelayConfig();
      const artifactDirectoryLocation =
        getRelayArtifactDirectoryLocation(relayConfig);

      console.log(
        `Artifact directory location: ${artifactDirectoryLocation}\n`
      );

      console.log("Getting all generated files...\n");
      const allGeneratedFiles = await getAllGeneratedFiles(
        artifactDirectoryLocation
      );
      console.log(
        `Number of generated files found in artifact directory: ${allGeneratedFiles.length}\n`
      );

      console.log("Looking up source files\n");

      const files = await findAllSourceFilesFromGeneratedFiles(
        allGeneratedFiles
      );

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
};
