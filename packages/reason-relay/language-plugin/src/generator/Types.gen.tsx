/* TypeScript file generated from Types.re by genType. */
/* eslint-disable import/first */


// tslint:disable-next-line:interface-over-type-literal
export type operationType = 
    { tag: "Fragment"; value: [string, boolean] }
  | { tag: "Mutation"; value: string }
  | { tag: "Subscription"; value: string }
  | { tag: "Query"; value: string };
