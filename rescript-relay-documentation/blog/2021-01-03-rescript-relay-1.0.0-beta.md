---
id: rescript-relay-1.0.0-beta
title: RescriptRelay 1.0.0 beta
author: Gabriel Nordeborn
authorTitle: Maintainer of RescriptRelay
authorURL: https://github.com/zth
authorImageURL: https://github.com/zth.png
authorTwitter: ___zth___
tags: ["releases"]
---

It's finally here - the first beta of the first stable RescriptRelay version! This is a huge milestone for the RescriptRelay project. Thank you everyone who's helped out with testing (and PR:s) for this release!

Follow the instructions in the [changelog](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#100-beta1) to install and try it out, and make sure you post any issues you encounter on [the issue tracker](https://github.com/zth/rescript-relay/issues). `1.0.0-beta.1` already runs in production in a mid-sized product, and has been tried on multiple code bases of varying sizes, so it should already be pretty stable.

## What's new in `1.0.0`

The big news in `1.0.0` is that RescriptRelay has been fully integrated into the new Relay Rust compiler. This means that the ReScript type generation has been rewritten from the old combination of ReasonML and TypeScript, into 100% Rust. Having the type generation deeply integrated into the Rust compiler comes with the following benefits:

1. _Speed_. The new Rust based compiler is ~7-10x faster than the current compiler. And even faster than that for incremental recompiles. This is in part thanks to Rust being a fast language, and also thanks to type generation now happening in the same process as the rest of the compilation, rather than being shelled out to a separate process like before.
2. Future proofing. The old JS based compiler has been killed, and the new Rust Relay compiler already has a bunch of features we can now use that would've never made it into the JS compiler. One example is the `@required` directive that can force nullable fields to be non-null. Perfect when dealing with views that requires data to be present that's nullable in the schema, letting the nullability bubble to one central place.
3. More advanced features. Being 100% integrated into the Relay compiler itself means we have access to all of the things the compiler has access to when generating our types and artifacts. This means we'll be able to build much more advanced and deeply integrated features than we could've ever done with the old compiler.

For this, we've forked the Relay compiler to make a few, surgical changes to support what we need for ReScript type generation. The fork changes very little in the core compiler, so maintaining the fork going forward should be really easy.

### Breaking changes?

Moving to the new compiler should be fairly seamless. Basically, you shouldn't need to change anything at all on the RescriptRelay side. Just install the new package and restart the compiler, and you should be good to go. Check out the [changelog](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#100-beta1) for more details on all of the changes in `1.0.0`.

## What lies ahead

Shipping `1.0.0` will be a significant milestone for the RescriptRelay project. But, development is unlikely to slow down with releasing `1.0.0`. Instead, we're now able to start exploring a bunch of things we couldn't explore before. Here's a non-exhaustive list of what'll happen in the coming year for RescriptRelay.

- Integrating the Relay LSP. The Relay team has built a dedicated LSP for Relay in parallel with the Rust rewrite. The LSP has a bunch of really nice Relay specific IDE functionality like displaying Relay problems directly in the editor, autocompleting fragments, autocompleting fragment arguments, etc. We'd like to integrate this into the [RescriptRelay VSCode extension](/docs/vscode-extension)
- Exploring a "dual mode" for easy integration with existing TypeScript code bases. This would mean that you could start using RescriptRelay in your existing Relay TypeScript code base as easily as possible. Something that's possible today, [but is cumbersome](/docs/migrating-from-javascript-typescript-incrementally).
- Content! A _ton_ of content for everything you need to know and learn in order to build great UI using RescriptRelay. Learning the Relay paradigm, neat tricks you can use with ReScript, etc. A comprehensive resource for everything you need.

## Fun things are ahead!

RescriptRelay is here to stay, and I'm very excited to continue working on it together with all of you great contributors and users. Special shout out to everyone active in [the Discord](https://discord.gg/wzj4EN8XDc) who's giving encouragement, helping out testing and so on.

Thank you for reading!
