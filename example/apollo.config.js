module.exports = {
  client: {
    tagName: "graphql",
    includes: ["./src/**/*.re"],
    service: {
      name: "graphql-schema",
      localSchemaFile: "./schema.graphql"
    }
  }
};
