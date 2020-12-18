const RelayReasonGenerator = require("./RelayReasonGenerator");

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
  outputExtension: "re",
  schemaExtensions: [],
  typeGenerator: RelayReasonGenerator,
  formatModule: formatGeneratedModule,
  findGraphQLTags: find,
  isGeneratedFile: (fileName: string) =>
    fileName.endsWith("_graphql.re") || fileName.endsWith(".bs.js"),
  keepExtraFile: (fileName: string) => fileName.endsWith(".bs.js"),
  getFileFilter,
  getModuleName: (operationName: string) => `${operationName}_graphql`,
});
