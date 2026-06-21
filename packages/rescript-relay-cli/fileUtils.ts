import glob from "fast-glob";
import ora from "ora";
import path from "path";
import fs from "fs";
import { cosmiconfigSync } from "cosmiconfig";
import type { Config } from "relay-compiler/lib/bin/RelayCompilerMain";

const config = cosmiconfigSync("relay", {
  searchPlaces: [
    "package.json",
    "relay.json",
    "relay.config.json",
    "relay.config.js",
    "relay.config.cjs",
  ],
});

export const loadRelayConfig = () => {
  const res = config.search();

  if (!res) {
    console.error(
      "Could not find relay.config.js. You must configure Relay through relay.config.js for RescriptRelay to work."
    );

    process.exit(1);
  }

  const relayConfig: Config = res.config;

  if (!relayConfig.artifactDirectory) {
    console.error(
      "RescriptRelay requires you to define 'artifactDirectory' (for outputing generated files in a single directory) in your relay.config.js. Please define it and re-run this command."
    );
    process.exit(1);
  }

  return relayConfig;
};

export const getRelayArtifactDirectoryLocation = (relayConfig: Config) => {
  const artifactDirectoryLocation = path.resolve(
    path.join(process.cwd(), relayConfig.artifactDirectory!)
  );

  return artifactDirectoryLocation;
};

export const getAllGeneratedFiles = async (
  artifactDirectoryLocation: string
) => {
  const allGeneratedFiles = await glob(`${artifactDirectoryLocation}/*.res`, {
    absolute: true,
    onlyFiles: true,
  });

  return allGeneratedFiles;
};

export const sourceLocExtractor = new RegExp(
  /(?<=\/\* @sourceLoc )[A-Za-z_.0-9]+(?= \*\/)/g
);

export const findAllSourceFilesFromGeneratedFiles = async (
  allGeneratedFiles: string[],
  spinner?: ora.Ora
) => {
  const sourceLocs = await Promise.all(
    allGeneratedFiles.map(async (fileLocation) => {
      if (spinner != null) {
        spinner.text = `Checking ${path.basename(fileLocation)}...`;
      }

      const fileContents = await fs.promises.readFile(fileLocation, {
        encoding: "utf-8",
      });

      return fileContents.match(sourceLocExtractor)?.[0];
    })
  );

  const sourcesToFind = sourceLocs.reduce((acc: string[], curr) => {
    if (curr != null) {
      const targetPath = curr;
      if (!acc.includes(targetPath)) {
        acc.push(targetPath);
      }
      return acc;
    }

    return acc;
  }, []);

  return sourcesToFind;
};

export const getSrcCwd = (src: string) =>
  path.resolve(path.join(process.cwd(), src));

export const getRelayExcludes = (
  relayConfig: Partial<Config> & { excludes?: string[] }
): string[] => relayConfig.excludes ?? relayConfig.exclude ?? [];

const findAncestorContaining = (startDir: string, relativeFilePath: string) => {
  let currentDir = path.resolve(startDir);

  while (true) {
    const candidate = path.join(currentDir, relativeFilePath);

    if (fs.existsSync(candidate)) {
      return currentDir;
    }

    const parentDir = path.dirname(currentDir);

    if (parentDir === currentDir) {
      return null;
    }

    currentDir = parentDir;
  }
};

export const getReanalyzeCwd = (startDir: string) =>
  findAncestorContaining(startDir, path.join("lib", "bs", ".sourcedirs.json")) ??
  startDir;

export const getRescriptToolsCommand = (startDir: string) => {
  const rescriptToolsRoot = findAncestorContaining(
    startDir,
    path.join("node_modules", "rescript", "cli", "rescript-tools.js")
  );

  if (rescriptToolsRoot != null) {
    return {
      command: process.execPath,
      args: [
        path.join(
          rescriptToolsRoot,
          "node_modules",
          "rescript",
          "cli",
          "rescript-tools.js"
        ),
        "reanalyze",
        "-dce",
      ],
    };
  }

  const binName =
    process.platform === "win32" ? "rescript-tools.cmd" : "rescript-tools";
  const packageRoot = findAncestorContaining(
    startDir,
    path.join("node_modules", ".bin", binName)
  );

  if (packageRoot != null) {
    return {
      command: path.join(packageRoot, "node_modules", ".bin", binName),
      args: ["reanalyze", "-dce"],
    };
  }

  return {
    command: "npx",
    args: ["--yes", "@rescript/tools", "reanalyze", "-dce"],
  };
};

export const findSourceFiles = async (
  fileNames: string[],
  src: string,
  excludes: string[] = []
) => {
  const cwd = getSrcCwd(src);

  const files = await glob(
    fileNames.map((name) => `**/${name}`),
    {
      cwd,
      absolute: true,
      ignore: excludes,
      onlyFiles: true,
    }
  );

  return files;
};
