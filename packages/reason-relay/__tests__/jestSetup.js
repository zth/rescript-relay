global.fetch = require("node-fetch");
const queryMock = require("./queryMock");

beforeEach(() => {
  queryMock.setup("http://graphql/");
});
