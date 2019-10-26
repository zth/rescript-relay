---
id: start-here
title: Start Here
sidebar_label: Start Here
---

Welcome to ReasonRelay! This section will introduce you to ReasonRelay, it's current state and what to expect.

If you feel you already know Reason, React (including Suspense + Concurrent Mode) and Relay, and just want to jump into the actual code, you can [go to getting started right away](getting-started).

## This is bleeding edge; React Suspense and Concurrent Mode, experimental Relay API's

The Relay API's we bind to are currently experimental, and implemented using React's experimental Suspense and Concurrent Mode features. You're encouraged to [read this section of the React documentation](https://reactjs.org/docs/concurrent-mode-intro.html) explaining Suspense and Concurrent Mode. This documentation will assume familiarity with both.

You're also encouraged to read [this excellent part of the Relay documentation](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay), guiding you through thinking in Relay and using the hooks API that's what ReasonRelay binds to.

_This means that the current version of ReasonRelay is to be seen as experimental until the point where React and Relay release their experimental API's as stable_. This is worth keeping in mind.

## An opinionated binding to Relay

ReasonRelay does _not_ aim to be a 1-to-1 binding of all of Relay. Rather, we take the following approach:

- Focus on binding the parts that lend themselves well to ReasonML's type system. In our case, this means _we only bind Relay's hooks, not their higher-order components_.
- Include tools and utilities that help make life with Relay easier. This includes simplifying common patterns like updating the store, dealing with connections and so on.

This means there's quite a large part of the API surface we won't cover. Rest assured though, what we won't cover will only be _additional ways of doing the same thing_.
