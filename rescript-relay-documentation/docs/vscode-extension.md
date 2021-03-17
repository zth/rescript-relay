---
id: vscode-extension
title: Dedicated VSCode extension
sidebar_label: Dedicated VSCode extension
---

There's a [dedicated VSCode extension](https://marketplace.visualstudio.com/items?itemName=GabrielNordeborn.vscode-rescript-relay) for using RescriptRelay with VSCode and ReScript syntax. You are **very encouraged** to use that if you can. I promise it'll make life simpler for you.

_Short video detailing the extension is coming soon_.

## Prerequisites

In order to use the dedicated VSCode extension, you need to satisfy the following requirements:

1. Using only ReScript syntax. The extension won't work for ReasonML syntax.
2. Using `rescript-relay >= 0.13.0`

### What does it do?

The extension aims to make life using RescriptRelay as simple and efficient as possible. There's a [full list of features available here](https://marketplace.visualstudio.com/items?itemName=GabrielNordeborn.vscode-rescript-relay), but let's take a brief tour of the most important ones:

#### Running the Relay compiler for you

The extension will run the Relay compiler for you, and report any error the compiler yields right in VSCode. You can basically forget that the compiler exists.

#### Formating, highlighting and autocomplete

The extension will ensure that all of your GraphQL code is:

- Formated via Prettier
- Properly syntax highlighted
- Autocompleted via your GraphQL schema

#### Codegen and GraphQL refactoring

The extension lets you effortlessly:

- Generate new operations and fragments + boiler plate components via the commands `> Add query`, `> Add fragment`, `> Add mutation` and `> Add subscription`
- Add new fragments and fragment components right via your GraphQL
- Extracting GraphQL selections into their own fragment components
- Do a large number of refactors in your GraphQL code, like setting up pagination, adding `@argumentDefinitions`, etc
