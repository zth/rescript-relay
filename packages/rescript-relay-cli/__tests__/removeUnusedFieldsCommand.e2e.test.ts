import cp from "child_process";
import fs from "fs";
import path from "path";

jest.setTimeout(120000);

const packageRoot = path.resolve(__dirname, "..");
const rescriptRelayRoot = path.resolve(packageRoot, "..", "rescript-relay");
const fixtureRoot = path.join(
  __dirname,
  "fixtures",
  "remove-unused-fields-monorepo"
);
const webRoot = path.join(fixtureRoot, "packages", "web");
const sourceFile = path.join(webRoot, "src", "OrganizationCard.res");
const artifactDirectory = path.join(webRoot, "src", "__relay__");
const cliDist = path.join(fixtureRoot, ".cli-dist");
const cliEntrypoint = path.join(cliDist, "index.js");
const originalCwd = process.cwd();

const generatedDirectories = [
  ".cli-dist",
  ".pnp.cjs",
  ".pnp.loader.mjs",
  ".yarn",
  "lib",
  "node_modules",
  "packages/web/lib",
  "packages/web/node_modules",
];

const cleanupArtifactDirectory = () => {
  if (!fs.existsSync(artifactDirectory)) {
    return;
  }

  for (const fileName of fs.readdirSync(artifactDirectory)) {
    if (fileName !== ".gitkeep") {
      fs.rmSync(path.join(artifactDirectory, fileName), {
        recursive: true,
        force: true,
      });
    }
  }
};

const cleanupFixtureGeneratedFiles = () => {
  for (const relativePath of generatedDirectories) {
    fs.rmSync(path.join(fixtureRoot, relativePath), {
      recursive: true,
      force: true,
    });
  }

  cleanupArtifactDirectory();
};

const prepareInstalledRescriptRelayPackage = () => {
  const localCompiler = path.join(
    rescriptRelayRoot,
    process.platform === "win32"
      ? "rescript-relay-compiler.exe"
      : "rescript-relay-compiler"
  );
  const installedCompiler = path.join(
    fixtureRoot,
    "node_modules",
    "rescript-relay",
    "rescript-relay-compiler.exe"
  );

  if (!fs.existsSync(localCompiler)) {
    runCommand("./build-compiler-dev.sh", [], rescriptRelayRoot);
  }

  fs.copyFileSync(localCompiler, installedCompiler);
  fs.chmodSync(installedCompiler, 0o755);
};

process.once("exit", cleanupFixtureGeneratedFiles);

const runProcess = (command: string, args: string[], cwd: string) => {
  const result = cp.spawnSync(command, args, {
    cwd,
    encoding: "utf-8",
    env: {
      ...process.env,
      COREPACK_ENABLE_DOWNLOAD_PROMPT: "0",
      FORCE_NO_WATCHMAN: "1",
      YARN_ENABLE_GLOBAL_CACHE: "false",
    },
  });
  const output = `${result.stdout ?? ""}${result.stderr ?? ""}`;

  if (result.error != null) {
    throw new Error(
      `${command} ${args.join(" ")} failed in ${cwd}\n\n${result.error.message}`
    );
  }

  return {
    output,
    status: result.status,
  };
};

const runCommand = (command: string, args: string[], cwd: string) => {
  const result = runProcess(command, args, cwd);

  if (result.status !== 0) {
    throw new Error(
      `${command} ${args.join(" ")} failed in ${cwd}\n\n${result.output}`
    );
  }

  return result.output;
};

describe("remove-unused-fields E2E", () => {
  beforeAll(() => {
    process.chdir(originalCwd);
    cleanupFixtureGeneratedFiles();
    runCommand("yarn", ["install", "--frozen-lockfile"], fixtureRoot);
    prepareInstalledRescriptRelayPackage();
    fs.mkdirSync(artifactDirectory, { recursive: true });
    runCommand("yarn", ["relay"], fixtureRoot);
    runCommand("yarn", ["rescript:build"], fixtureRoot);
    runCommand(
      path.join(
        packageRoot,
        "node_modules",
        ".bin",
        process.platform === "win32" ? "ncc.cmd" : "ncc"
      ),
      ["build", "index.ts", "-o", cliDist, "-m"],
      packageRoot
    );
  });

  afterEach(() => {
    process.chdir(originalCwd);
  });

  afterAll(() => {
    process.chdir(originalCwd);
    cleanupFixtureGeneratedFiles();
  });

  it("gets unused generated fields from a real Yarn monorepo reanalyze run", () => {
    const output = runCommand("yarn", ["reanalyze"], fixtureRoot);

    expect(output).toContain("IndexQuery_graphql.res");
    expect(output).toContain(
      "Types.response.currentOrg is a record label never used to read a value"
    );
    expect(output).toContain("OrganizationCard_graphql.res");
    expect(output).toContain(
      "Types.fragment.currentUserIsAdmin is a record label never used to read a value"
    );
  });

  it("uses the monorepo analysis root when the real CLI reports CI failures from a package", () => {
    const sourceBefore = fs.readFileSync(sourceFile, "utf-8");
    const result = runProcess(
      process.execPath,
      [cliEntrypoint, "remove-unused-fields", "--ci"],
      webRoot
    );

    expect(result.status).toBe(1);
    expect(result.output).toContain("Found 2 file(s) with unused fields.");
    expect(fs.readFileSync(sourceFile, "utf-8")).toBe(sourceBefore);
  });
});
