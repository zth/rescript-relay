import { DefinitionNode, DocumentNode } from "graphql";
import "relay-compiler";
import { Fragment, Parser, Root, Schema } from "relay-compiler";

declare module "relay-compiler" {
  const convertASTDocuments: (
    extendedSchema: Schema,
    ast: DocumentNode[],
    parser: (
      schema: Schema,
      documents: DefinitionNode[]
    ) => readonly (Root | Fragment)[]
  ) => readonly (Fragment | Root)[];
}
