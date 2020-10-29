import { parse } from "graphql";
import {
  convertASTDocuments,
  Fragment,
  Parser,
  Root,
  Schema,
} from "relay-compiler";

const parseGraphQLText = (
  schema: Schema,
  text: string
): {
  definitions: ReadonlyArray<Fragment | Root>;
  schema: Schema;
} => {
  const ast = parse(text);

  const extendedSchema = schema.extend(ast);

  const definitions = convertASTDocuments(
    extendedSchema,
    [ast],
    Parser.transform.bind(Parser)
  );

  return {
    definitions,
    schema: extendedSchema,
  };
};

export default parseGraphQLText;
