import "graphql";

declare module "graphql" {
  const stripIgnoredCharacters: (source: string) => string;
}
