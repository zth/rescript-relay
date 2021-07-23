---
id: codebase-health-considerations
title: Codebase Health Considerations
sidebar_label: Codebase Health Considerations
---

RescriptRelay is all about shipping code that's safe, healthy and ages well. Because of this focus, a lot of effort goes into tooling that help you achieve this. Here's a few things you can consider using to help keep your code base healthy, and your production code safe.

## Ensuring the compiler has always run

It's important that the Relay compiler has always run before you commit and deploy your changes, so the generated Relay code is in sync with your ReScript code.

An easy way of enforcing this is to run the Relay compiler in CI, and make sure no files were changed. This means you're in sync. [Here's an example](https://github.com/zth/rescript-relay/blob/a34f05ab1a904c316fb15aee6d8e10cc11482d23/.github/workflows/integration-tests.yml#L48-L59) of this added to a GitHub CI action.

> Remember, the Relay compiler should run _before_ the ReScript compiler when building.

## Ensuring no unused fields exists

RescriptRelay comes with [a CLI](rescript-relay-cli) that automates removing unused fields for you. Running [`yarn rescript-relay-cli remove-unused-fields`](rescript-relay-cli#remove-unused-fields) will automatically remove unused fields from your GraphQL fragments and queries.

It's a good idea to run this in CI, to make sure no unused field can escape into production. Adding it to CI is simple enough - just set up an action that runs `yarn rescript-relay-cli remove-unused-fields --ci` after the Relay compiler and the ReScript compiler has run.

That command will exit with a status code of 1 if it finds any unused fields, allowing you to propagate that error and fail CI.

Read more [in the CLI docs](rescript-relay-cli#remove-unused-fields).

## Making sure your GraphQL operations are formatted

This is a bit opinionated, but I think most can agree that autoformatting of code is the best thing that has happened since sliced bread.

JS/TS land has `prettier`, an awesome formatter that can format just about anything. ReScript has a great autoformatter as well, but it only formats ReScript code. So, the GraphQL you write won't be automatically formatted.

This can be quite annoying as formatting code is tiresome, and unformatted code can lead to inconsistent and hard to read diffs (not to mention bikeshedding around the formatting itself). Therefore, RescriptRelay ships with commands for formatting GraphQL that's embedded in ReScript.

But don't despair, RescriptRelay has you covered! `yarn rescript-relay-cli format-all-graphql` will format all GraphQL operations in the entire project, using `prettier`. There's also a separate command that you can use to format a single file.

Read more about [the commands here](rescript-relay-cli#format-all-graphql).

> If you're using our [dedicated VSCode extension](vscode-extension), any file you edit and save will automatically have its GraphQL operations formatted using `prettier` already.
