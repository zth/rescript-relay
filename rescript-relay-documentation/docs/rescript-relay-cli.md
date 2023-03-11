---
id: rescript-relay-cli
title: RescriptRelay CLI
sidebar_label: RescriptRelay CLI
---

`rescript-relay-cli` is a CLI for making life using RescriptRelay just a tiny bit easier. It's automatically included with every release of `rescript-relay`.

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

#### Keeping fields safe from removal

If you want to keep fields around, even though you're not actively using them you can `ignore` them.
Let's say I have this fragment:

```
module Fragment = %relay(`
  fragment User_user on users {
    name
    email
  }
`)
```

And I use the field `name` in my markup; `<div>{React.string(user.name)}</div>`.
When I run `remove-unused-fields` the email field will be removed.
If I for some reason need to keep the `email` around I can call `ignore(user.email)` and then it will be safe.

#### Ignoring entire fragments

Sometimes you want to consider _all_ fields in a fragment used, regardless of whether they're used or not. This should be rare, but if you do, you can add `@rescriptRelayIgnoreUnused` to your fragment definition, and the CLI will ignore this fragment when it looks for unused fields.

```rescript
// Analysis will skip checking if the fields in this fragment are unused, and always consider them as used.
module Fragment = %relay(`
  fragment SomeUserFragment_user on User @rescriptRelayIgnoreUnused {
    firstName
    lastName
  }
`)
```

#### CLI options

##### `--ci`

This runs the script in "CI mode", meaning it'll only report whether there are unused fields or not (but not actually remove them), making it suitable for running in CI, like in a GitHub action. Use this mode to make sure unused fields and overfetching never makes it into production.

##### `--verbose`

This will output information around which unused fields are found, and in what file/definition they're located.

### format-all-graphql

Formats all GraphQL operations in the project using [`prettier`](https://prettier.io/).

#### CLI options

##### `--ci`

This runs the script in "CI mode", meaning it'll only report whether there are unformatted files or not, making it suitable for running in CI, like in a GitHub action.

### format-single-graphql < absolute-path-to-file >

Formats all GraphQL operations in a single file [`prettier`](https://prettier.io/).
