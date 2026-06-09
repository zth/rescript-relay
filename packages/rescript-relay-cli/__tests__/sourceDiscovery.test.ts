import fs from "fs";
import os from "os";
import path from "path";
import {
  findSourceFiles,
  getReanalyzeCwd,
  getRescriptToolsCommand,
} from "../fileUtils";

describe("source discovery", () => {
  it("honors relay excludes when finding source files", async () => {
    const originalCwd = process.cwd();
    const root = fs.mkdtempSync(
      path.join(os.tmpdir(), "rescript-relay-source-discovery-")
    );
    const projectRoot = path.join(root, "packages", "web");

    try {
      fs.mkdirSync(path.join(projectRoot, "src"), { recursive: true });
      fs.mkdirSync(path.join(projectRoot, "lib", "ocaml"), {
        recursive: true,
      });
      fs.writeFileSync(
        path.join(projectRoot, "src", "OrganizationSettings.res"),
        "let actualSource = true\n",
        { encoding: "utf-8" }
      );
      fs.writeFileSync(
        path.join(projectRoot, "lib", "ocaml", "OrganizationSettings.res"),
        "let compiledCopy = true\n",
        { encoding: "utf-8" }
      );

      process.chdir(projectRoot);

      const sourceFiles = await findSourceFiles(
        ["OrganizationSettings.res"],
        ".",
        ["**/lib/**"]
      );

      expect(sourceFiles.map((file) => fs.realpathSync(file))).toEqual([
        fs.realpathSync(
          path.join(projectRoot, "src", "OrganizationSettings.res")
        ),
      ]);
    } finally {
      process.chdir(originalCwd);
      fs.rmSync(root, { recursive: true, force: true });
    }
  });

  it("uses the ancestor ReScript analysis root and ReScript tools wrapper", () => {
    const root = fs.mkdtempSync(
      path.join(os.tmpdir(), "rescript-relay-source-discovery-")
    );
    const webRoot = path.join(root, "packages", "web");

    try {
      fs.mkdirSync(path.join(root, "lib", "bs"), { recursive: true });
      fs.mkdirSync(path.join(root, "node_modules", "rescript", "cli"), {
        recursive: true,
      });
      fs.mkdirSync(webRoot, { recursive: true });
      fs.writeFileSync(
        path.join(root, "lib", "bs", ".sourcedirs.json"),
        "[]\n",
        { encoding: "utf-8" }
      );
      fs.writeFileSync(
        path.join(
          root,
          "node_modules",
          "rescript",
          "cli",
          "rescript-tools.js"
        ),
        "",
        { encoding: "utf-8" }
      );

      expect(getReanalyzeCwd(webRoot)).toBe(root);
      expect(getRescriptToolsCommand(webRoot)).toEqual({
        command: process.execPath,
        args: [
          path.join(
            root,
            "node_modules",
            "rescript",
            "cli",
            "rescript-tools.js"
          ),
          "reanalyze",
          "-dce",
        ],
      });
    } finally {
      fs.rmSync(root, { recursive: true, force: true });
    }
  });
});
