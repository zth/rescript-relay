# rescript-relay-cli

A CLI for making life using RescriptRelay just a tiny bit easier. It's automatically included with every release of `rescript-relay`.
_This will be considered experimental for a few releases, please report any bugs you encounter._

## Commands

### remove-unused-fields

This command will remove any unused fields it can find in your project, helping you avoid overfetching. An unused field means a field that's in a fragment or query defintion, but never actually used in the code. There are a few caveats, but thanks to ReScripts incredible type system, and [`reanalyze`](https://github.com/rescript-association/reanalyze), it's very accurate.

Usage:

```
# Make sure you run the Relay compiler, and compile ReScript, before running this command
yarn rescript-relay-cli remove-unused-fields
```

Here's a non exhaustive list of what unused fields the script can remove automatically:

- Unused fields anywhere in the fragment/query
- Entire fragments or queries, if nothing in those fragments or queries are actually used
- Full union member selections, if the member is no longer in use
- All fragment spreads, if none of the fragment spreads are used

#### CLI options

##### `--ci`

This runs the script in "CI mode", meaning it'll only report whether there are unused fields or not (but not actually remove them), making it suitable for running in CI, like in a GitHub action. Use this mode to make sure unused fields and overfetching never makes it into production.

##### `--verbose`

This will output information around which unused fields are found, and in what file/definition they're located.

### format-all-graphql

Formats all GraphQL operations in the project using [`prettier`](https://prettier.io/).

### format-single-graphql <absolute-path-to-file>

Formats all GraphQL operations in a single file [`prettier`](https://prettier.io/).
