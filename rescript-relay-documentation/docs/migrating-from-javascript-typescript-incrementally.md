---
id: migrating-from-javascript-typescript-incrementally
title: Migrating from Javascript/Typescript incrementally
sidebar_label: Migrating from Javascript/Typescript incrementally
---

There are several scenarios in which it would be a good idea to migrate from either Javascript or TypeScript incrementally rather than in one go. Here are a few of them:

- Your codebase is large and you want to make sure the converted code works without any problems as you go along.
- You would like to introduce ReScript to your team by duplicating small portion of your project using ReScript for side-by-side comparison.
- You are not fully convinced ReScript is the right choice for your project and you want to take it for a spin by writing some useful Rescript code you are able to keep if you decide to stick with it.

### Strategy

While it's technically possible to migrate using "top-down" strategy starting with your entry point and moving down one-by-one to all your dependencies, it is much easier and efficient, if you use a "leaf-first" approach. You start with part of the code that don't have dependencies to any other part of your code and move up the dependency tree. Rescript generates Javascript code, which can directly be imported by your unconverted codebase whereas if you wanted to use your unconverted JS/TS code in ReScript, you would have to write bindings for them, which probably wouldn't be the best use of your time since eventually they will all be converted to ReScript modules anyway which can then be used directly by your Rescript code without needing any bindings.

### Interop

Sharing fragments between ReScript and JS/TS is tricky to automate. That's because the JS/TS compiler cannot pick up GraphQL from anything but JS/TS files, and ReScript won't output them. The absolute easiest way is to simply keep two versions of the fragments as you transition - one in a JS/TS file and one in a ReScript file. The important thing is that the compiler can pick them up (so it's fine if the JS/TS file for instance only has the fragment in the entire file, and nothing else).

There's no getting away from running the compiler twice: once for ReScript and once for JS/TS. Both expect either relay.json or relay.js configuration file in your project's root folder. Unfortunately the Relay compiler's CLI version does not have an option for using a different config file. That means if you wanted to use scripts in you package.json to run both compilers, you would have to temporarily set an environment variable before running either command. You could then use that environment variable in your relay.js file to augment it accordingly depending if you're running RescriptRelay compiler or React-Relay compiler.

Setting up both compilers sharing the same config is a bit inconvenient, but the good news after you have done that, there isn't much else that needs your attention in order to use both RescriptRelay (ReScript) and React-Relay (JS/TS) in the same app. When it comes to runtime, what actually matters for Relay is the artifact that's output from the compiler, and that should be 100% the same across languages.

### Step-by-step guide

So, in short, a way of gradually transitioning from JS/TS to ReScript could be:

- First, set up the compiler for both languages.
- Now, let's say you want to migrate the Avatar component from TS to ReScript, add a new Avatar ReScript file.
- Build up your component in ReScript and add the exact same Avatar fragment there as in TS.
- Then, start switching out the call sites from the TS Avatar component to the ReScript one.
- When you've replaced all of the call sites, you can remove everything but the GraphQL Avatar fragment definition in the Avatar file. That'll need to remain as long as any TS component references the Avatar component still, but everything else can be removed.
- Rinse and repeat.
