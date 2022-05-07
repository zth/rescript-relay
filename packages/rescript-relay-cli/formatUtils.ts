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
    const isCommented = thisTag.content
      .split("\n")
      .some((line) => line.trim().startsWith("//"));
    if (isCommented) {
      // Uncomment the `tag`, format it and then comment it back
      const uncommentedContent = thisTag.content
        .split("\n")
        .map((line) => line.replace("//", ""))
        .join("\n");
      formatted += restoreOperationPadding(
        prettify(uncommentedContent),
        uncommentedContent
      )
        .split("\n")
        // Ignore empty lines
        .map((line) => (line !== "" ? `//${line}` : line))
        .join("\n");
    } else {
      formatted += restoreOperationPadding(
        prettify(thisTag.content),
        thisTag.content
      );
    }
  }

  const lastTag = tags[tags.length - 1];
  formatted += doc.slice(lastTag.end);

  return formatted;
};
