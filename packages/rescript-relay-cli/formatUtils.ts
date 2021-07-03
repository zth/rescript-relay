import {
  extractGraphQLSourceFromReScript,
  prettify,
  restoreOperationPadding,
} from "./cliUtils";

export const formatOperationsInDocument = (doc: string): string => {
  const tags = extractGraphQLSourceFromReScript(doc);

  if (tags.length === 0) {
    return doc;
  }

  let formatted = "";

  for (let i = 0; i <= tags.length - 1; i += 1) {
    const thisTag = tags[i];
    const lastTag = tags[i - 1];
    const lastTagEnd = lastTag == null ? 0 : lastTag.end;

    formatted += doc.slice(lastTagEnd, thisTag.start);
    formatted += restoreOperationPadding(
      prettify(thisTag.content),
      thisTag.content
    );
  }

  const lastTag = tags[tags.length - 1];
  formatted += doc.slice(lastTag.end);

  return formatted;
};
