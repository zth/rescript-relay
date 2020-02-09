const IRTransformer = require("relay-compiler/lib/core/GraphQLIRTransformer");
const {
  createUserError
} = require("relay-compiler/lib/core/RelayCompilerError");
const { reservedKeywords } = require("../generator/ReservedKeywords.gen");

type DisallowedResult = {
  disallowed: boolean;
  message: string;
};

let reservedKeywordsInReasonRelay = [
  "fragment",
  "t_fragment",
  "subscription",
  "mutation",
  "response",
  "variables",
  "refetchVariables",
  "t",
  "fragmentRef",
  "fragmentRefSelector",
  "operationType"
];

function isDisallowedName(name: string): DisallowedResult {
  let firstChar = name[0];

  if (/[A-Z]/.test(firstChar)) {
    return {
      disallowed: true,
      message: `Field names may not start with an uppercase letter. Please alias the '${name}' field to something starting with a lowercase letter.`
    };
  }

  if (reservedKeywords.includes(name)) {
    return {
      disallowed: true,
      message: `'${name}' is a reserved keyword in ReasonML and therefore cannot be used as a field name. Please alias your field to something else.`
    };
  }

  if (reservedKeywordsInReasonRelay.includes(name)) {
    return {
      disallowed: true,
      message: `'${name}' is a reserved keyword in ReasonRelay and therefore cannot be used as a field name. Please alias your field to something else.`
    };
  }

  return { disallowed: false, message: "" };
}

function checkDisallowed(field: any) {
  if (field.alias) {
    let { disallowed, message } = isDisallowedName(field.alias);

    if (disallowed) {
      throw createUserError("Found an invalid field name: " + message, [
        field.loc
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
    LinkedField: visitField
  });
}
