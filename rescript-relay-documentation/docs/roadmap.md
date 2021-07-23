---
id: roadmap
title: RescriptRelay Roadmap
sidebar_label: Roadmap
---

This loosely details the roadmap of RescriptRelay. It's intentionally vague because open source is hard and time consuming, but it should give you a general idea of where the project is headed.

The items on the roadmap are in order of importance/impact, but not necessary in order of when they'll be worked on.

## 1. Integrating the new Relay Rust compiler

Relay's compiler has recently been rewritten in Rust. It's not released as open source just yet, but it's ready enough for RescriptRelay to start integrating with it at some point.

### Benefits

Integrating the Relay Rust compiler will:

- Bring large performance wins, as the new compiler is a lot faster than the old JS based compiler
- Future proof RescriptRelay, as the JS based compiler will be deprecated
- Paving the way for integrating Relay's dedicated LSP into our VSCode extension

### Plan

Integrating the compiler will be done in two stages:

1. Bare minimum integration using the current type generation (written in native ReasonML/OCaml).
2. Move ReScript type generation to Rust and into the compiler itself.

## 2. Concurrent mode/suspense-enabled routing solution

The goal is for RescriptRelay to ship a routing solution that focuses on playing to Relay's strengths, with preloading of both code and data etc. Also potentially integrating even deeper into a number of Relay features few outside of Facebook uses, like preloading of component specific code, etc.

Work is already ongoing [here](experimental-router).

## 3. Examples and solutions to common problems

Extend documentation and examples to provide as many concrete solutions as possible to common scenarios and issues people experience when building apps with RescriptRelay.

This should be an up-to-date resource where it's incredibly easy to find examples of how to implement solutions for most scenarios you'll encounter when building apps.
