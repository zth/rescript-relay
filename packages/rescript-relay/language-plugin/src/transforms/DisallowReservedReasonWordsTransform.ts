const IRTransformer = require("relay-compiler/lib/core/IRTransformer");
const { createUserError } = require("relay-compiler/lib/core/CompilerError");

const reservedKeywords = [
  "and",
  "as",
  "asr",
  "assert",
  "begin",
  "class",
  "constraint",
  "do",
  "while",
  "for",
  "done",
  "while",
  "for",
  "downto",
  "else",
  "end",
  "exception",
  "external",
  "false",
  "for",
  "fun",
  "function",
  "functor",
  "if",
  "in",
  "include",
  "inherit",
  "initializer",
  "land",
  "lazy",
  "let",
  "lor",
  "lsl",
  "lsr",
  "lxor",
  "match",
  "method",
  "mod",
  "module",
  "open",
  "mutable",
  "new",
  "nonrec",
  "object",
  "of",
  "open",
  "open!",
  "or",
  "private",
  "rec",
  "let",
  "module",
  "sig",
  "struct",
  "then",
  "to",
  "true",
  "try",
  "type",
  "val",
  "virtual",
  "val",
  "method",
  "class",
  "when",
  "while",
  "with",
  // Reason specific words
  "switch",
];

type DisallowedResult = {
  disallowed: boolean;
  message: string;
};

let reservedKeywordsInRescriptRelay = [
  "fragment",
  "t_fragment",
  "subscription",
  "mutation",
  "response",
  "variables",
  "refetchVariables",
  "t",
  "fragmentRef",
  "fragmentRefs",
  "fragmentRefSelector",
  "operationType",
];

function isDisallowedName(name: string): DisallowedResult {
  let firstChar = name[0];

  if (/[A-Z]/.test(firstChar)) {
    return {
      disallowed: true,
      message: `Field names may not start with an uppercase letter. Please alias the '${name}' field to something starting with a lowercase letter.`,
    };
  }

  if (reservedKeywords.includes(name)) {
    return {
      disallowed: true,
      message: `'${name}' is a reserved keyword in ReasonML and therefore cannot be used as a field name. Please alias your field to something else.`,
    };
  }

  if (reservedKeywordsInRescriptRelay.includes(name)) {
    return {
      disallowed: true,
      message: `'${name}' is a reserved keyword in RescriptRelay and therefore cannot be used as a field name. Please alias your field to something else.`,
    };
  }

  return { disallowed: false, message: "" };
}

function checkDisallowed(field: any) {
  if (field.alias) {
    let { disallowed, message } = isDisallowedName(field.alias);

    if (disallowed) {
      throw createUserError("Found an invalid field name: " + message, [
        field.loc,
      ]);
    }
  }

  if (field.selections) {
    field.selections.forEach(checkDisallowed);
  }
}

function visitField(field: any) {
  checkDisallowed(field);
  return field;
}

export function transform(context: any) {
  return IRTransformer.transform(context, {
    ScalarField: visitField,
    LinkedField: visitField,
  });
}
