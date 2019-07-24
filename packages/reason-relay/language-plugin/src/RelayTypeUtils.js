// @flow
const nullthrows = require('nullthrows');

export type Selection = {
  key: string,
  schemaName?: string,
  value?: any,
  nodeType?: any,
  conditional?: boolean,
  concreteType?: string,
  ref?: string,
  nodeSelections?: ?SelectionMap
};
export type SelectionMap = Map<string, Selection>;

function mergeSelection(a: ?Selection, b: Selection): Selection {
  if (!a) {
    return {
      ...b,
      conditional: true
    };
  }
  return {
    ...a,
    nodeSelections: a.nodeSelections
      ? mergeSelections(a.nodeSelections, nullthrows(b.nodeSelections))
      : null,
    conditional: a.conditional && b.conditional
  };
}

function mergeSelections(a: SelectionMap, b: SelectionMap): SelectionMap {
  const merged = new Map();
  for (const [key, value] of a.entries()) {
    merged.set(key, value);
  }
  for (const [key, value] of b.entries()) {
    merged.set(key, mergeSelection(a.get(key), value));
  }
  return merged;
}

// $FlowFixMe
function isPlural(node: Fragment): boolean {
  return Boolean(node.metadata && node.metadata.plural);
}

function flattenArray<T>(arrayOfArrays: Array<Array<T>>): Array<T> {
  const result = [];
  arrayOfArrays.forEach(array => result.push(...array));
  return result;
}

const isTypenameSelection = (selection: Selection) => selection.schemaName === '__typename';
const hasTypenameSelection = (selections: Array<Selection>) => selections.some(isTypenameSelection);
const onlySelectsTypename = (selections: Array<Selection>) => selections.every(isTypenameSelection);

module.exports = {
  mergeSelection,
  mergeSelections,
  isPlural,
  flattenArray,
  isTypenameSelection,
  hasTypenameSelection,
  onlySelectsTypename
};
