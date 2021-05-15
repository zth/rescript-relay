const RescriptRelayGenerator = require("./RescriptRelayGenerator");

const formatGeneratedModule = require("./formatGeneratedModule");

const { find } = require("./FindGraphQLTags");
const path = require("path");
const fs = require("fs");

function getFileFilter(baseDir: string) {
  return (file: { relPath: string }) => {
    const filePath = path.join(baseDir, file.relPath);
    let text = "";
    try {
      text = fs.readFileSync(filePath, "utf8");
    } catch {
      // eslint-disable no-console
      console.warn(
        `RelaySourceModuleParser: Unable to read the file "${filePath}". Looks like it was removed.`
      );
      return false;
    }
    return text.indexOf("%relay") >= 0;
  };
}

module.exports = () => ({
  inputExtensions: ["re", "res"],
  outputExtension: "res",
  schemaExtensions: [],
  typeGenerator: RescriptRelayGenerator,
  formatModule: formatGeneratedModule,
  findGraphQLTags: find,
  isGeneratedFile: (fileName: string) =>
    fileName.endsWith("_graphql.res") ||
    fileName.endsWith(".js") ||
    fileName.endsWith(".mjs"),
  keepExtraFile: (fileName: string) =>
    fileName.endsWith(".js") || fileName.endsWith(".mjs"),
  getFileFilter,
  getModuleName: (operationName: string) => `${operationName}_graphql`,
});
