const IRTransformer = require("../../../src/vendor/relay-compiler/lib/core/GraphQLIRTransformer");
const {
  createUserError
} = require("../../../src/vendor/relay-compiler/lib/core/RelayCompilerError");
const {
  recordIndicatorKey,
  connectionIndicatorKey
} = require("../generator/Constants.gen.tsx");
import { Directive, Argument } from "relay-compiler";

type ReasonRelayDirectiveConfig = {
  [key: string]: string;
};

function directiveArgsToConfig(
  directive: Directive
): ReasonRelayDirectiveConfig {
  let config: ReasonRelayDirectiveConfig = {};

  directive.args.forEach((arg: Argument) => {
    switch (arg.name) {
      case "mode": {
        const val = arg.value;
        const value = val.kind === "Literal" ? val.value : null;

        if (typeof value === "string") {
          config.mode = value;
        }
        break;
      }
    }
  });

  return config;
}

function connectionArgsToConfig(directive: Directive): any {
  let config: any = {};

  directive.args.forEach((arg: Argument) => {
    switch (arg.name) {
      case "key": {
        const val = arg.value;
        const value = val.kind === "Literal" ? val.value : null;

        if (typeof value === "string") {
          config.key = value;
        }
        break;
      }
    }
  });

  return config;
}

function stringifyConfig(config: any): string {
  return Object.keys(config).reduce((acc, curr, index) => {
    let str = index === 0 ? curr : "$$$" + curr;
    str += "__$$__" + config[curr];

    return acc + str;
  }, "");
}

export function transform(context: any) {
  return IRTransformer.transform(context, {
    LinkedField: function(field: any) {
      /**
       * Look for our custom directive
       */
      const reasonRelayDirective = field.directives.find(
        (d: any) => d.name === "reasonRelay"
      );

      if (reasonRelayDirective) {
        const config = directiveArgsToConfig(reasonRelayDirective);
        const name = recordIndicatorKey + stringifyConfig(config);
        const schema = context.getSchema();

        field.selections.push({
          kind: "ScalarField",
          alias: name,
          args: [],
          directives: [],
          handles: null,
          loc: { kind: "Generated" },
          metadata: null,
          name,
          type: schema.expectStringType()
        });
      }

      /**
       * Look for connections
       */

      const connectionDirective = field.directives.find(
        (d: any) => d.name === "connection"
      );

      if (connectionDirective) {
        const name =
          connectionIndicatorKey +
          stringifyConfig({
            ...connectionArgsToConfig(connectionDirective),
            name: field.alias
          });
        const schema = context.getSchema();

        field.selections.push({
          kind: "ScalarField",
          alias: name,
          args: [],
          directives: [],
          handles: null,
          loc: { kind: "Generated" },
          metadata: null,
          name,
          type: schema.expectStringType()
        });
      }

      return field;
    }
  });
}

export const SCHEMA_EXTENSION = `
  enum ReasonRelayObjectMode {
    JsT
    Record
  }

  directive @reasonRelay(mode: ReasonRelayObjectMode) on OBJECT | FIELD | FRAGMENT_DEFINITION
  `;
