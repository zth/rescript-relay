---
id: start-here
title: Start Here
sidebar_label: Start Here
---

ReasonRelay is a way to use [Relay](https://relay.dev), a JavaScript client-side framework for building data-driven applications using GraphQL, together with [ReasonML](https://reasonml.github.io/). This page will briefly introduce the documentation, how it's structured and what to expect.

### A starting pointer

The following is worth keeping in mind:
ReasonRelay is to be seen as experimental software until React and Relay release the experimental APIs we rely on as stable. And since we're early in the life of ReasonRelay, breaking changes in some of the APIs may occur as we iterate on them.

With that said, the _goal is to make ReasonRelay a viable and attractive alternative for doing GraphQL with ReasonML in production_. That means that we'll do what we can to improve the bindings in a sane way without breaking things.

## Structure

The documentation is roughly divided into 3 parts:

##### 1. A walkthrough setting up ReasonRelay and introducing the main features

Each page in the walkthrough will introduce a concept from Relay and explain how to achieve the same thing in ReasonRelay. Each page will also have a section of _recommended background reading_ that you're encouraged to look into if you're not familiar with the concepts explained.

##### 2. An API reference covering the full ReasonRelay API surface

This will detail all modules, functions and concepts of ReasonRelay in good, old plain table form.

##### 3. Guides, tips and tricks

Here you'll find resources for making life with ReasonRelay easier.

## This is bleeding edge; React Suspense and Concurrent Mode, experimental Relay API's

The Relay API's we bind to are currently experimental, and implemented using React's experimental Suspense and Concurrent Mode features. You're encouraged to [read this section of the React documentation](https://reactjs.org/docs/concurrent-mode-intro.html) explaining Suspense and Concurrent Mode. This documentation will assume some familiarity with both.

You're also encouraged to read [this excellent part of the Relay documentation](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay), guiding you through thinking in Relay and using the hooks API that's what ReasonRelay binds to.

## The next step

Ok, enough introduction! Let's move on to [getting started](getting-started) and start setting up ReasonRelay in your project.
