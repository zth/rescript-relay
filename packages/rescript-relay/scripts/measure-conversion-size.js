#!/usr/bin/env node
// Measure complete compiled artifacts, not just instruction literals. Dependencies
// are external so application/runtime size is not mistaken for generated-code size.
const fs = require("fs");
const path = require("path");
const zlib = require("zlib");
const esbuild = require("esbuild");
const args = process.argv.slice(2);
const option = (name) => {
  const index = args.indexOf(name);
  return index < 0 ? undefined : args[index + 1];
};
const root = path.resolve(option("--root") || path.join(__dirname, ".."));
const manifest = JSON.parse(
  fs.readFileSync(
    path.join(__dirname, "../benchmarks/size-fixtures.json"),
    "utf8",
  ),
);
function size(bytes) {
  return {
    minified: bytes.length,
    gzip: zlib.gzipSync(bytes, { level: 9 }).length,
    brotli: zlib.brotliCompressSync(bytes, {
      params: { [zlib.constants.BROTLI_PARAM_QUALITY]: 11 },
    }).length,
  };
}
async function measure() {
  const common = {
    bundle: true,
    minify: true,
    format: "esm",
    platform: "browser",
    write: false,
    logLevel: "silent",
    plugins: [
      {
        name: "external-dependencies",
        setup(build) {
          build.onResolve({ filter: /.*/ }, (args) => {
            if (args.kind === "entry-point") return;
            return { path: args.path, external: true };
          });
        },
      },
    ],
  };
  const files = [];
  for (const relative of manifest) {
    const result = await esbuild.build({
      ...common,
      entryPoints: [path.join(root, relative)],
    });
    files.push({ path: relative, ...size(result.outputFiles[0].contents) });
  }
  // A genuine combined bundle of all fixture modules, with dependencies external.
  const combined = await esbuild.build({
    ...common,
    stdin: {
      contents: manifest
        .map(
          (p, i) =>
            `export * as artifact${i} from ${JSON.stringify(path.join(root, p))};`,
        )
        .join("\n"),
      resolveDir: root,
    },
    plugins: [
      {
        name: "external-dependencies",
        setup(build) {
          build.onResolve({ filter: /.*/ }, (args) => {
            if (args.importer === "<stdin>") return { path: args.path };
            return { path: args.path, external: true };
          });
        },
      },
    ],
  });
  const separate = files.reduce(
    (sum, file) =>
      Object.fromEntries(
        Object.keys(sum).map((key) => [key, sum[key] + file[key]]),
      ),
    { minified: 0, gzip: 0, brotli: 0 },
  );
  const report = {
    fixtureVersion: 1,
    esbuild: esbuild.version,
    node: process.version,
    artifactCount: files.length,
    combined: size(combined.outputFiles[0].contents),
    separate,
    files,
  };
  console.log(
    JSON.stringify(
      {
        artifactCount: report.artifactCount,
        combined: report.combined,
        separate,
      },
      null,
      2,
    ),
  );
  if (option("--output"))
    fs.writeFileSync(
      option("--output"),
      JSON.stringify(report, null, 2) + "\n",
    );
  if (args.includes("--check")) {
    // Intentional headroom. Changing the fixture manifest or minifier requires
    // reviewing these budgets; these do not claim to bound an application's size.
    const budgets = JSON.parse(
      fs.readFileSync(
        path.join(__dirname, "../benchmarks/size-budgets.json"),
        "utf8",
      ),
    );
    for (const mode of ["combined", "separate"])
      for (const key of ["minified", "gzip", "brotli"])
        if (report[mode][key] > budgets[mode][key])
          throw new Error(
            `${mode} ${key}: ${report[mode][key]} exceeds ${budgets[mode][key]}`,
          );
  }
}
measure().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
