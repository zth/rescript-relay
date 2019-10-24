# reason-relay

Bindings and a compiler plugin for using Relay with ReasonML.

_REQUIRES BuckleScript 6, which is currently in beta_

Please refer to ARCHITECTURE.md for a more thorough overview of the different parts and the reasoning behind them.

## Examples

- TodoMVC implemented in ReasonRelay: https://github.com/zth/relay-examples/tree/master/todo-reason
- A general example showcasing most available features: https://github.com/zth/reason-relay/tree/master/example

## Getting started

_Requires BuckleScript 6 (currently in beta), Relay == 7.0.0 and React >= 16.9.0_

```
# Add reason-relay to the project
yarn add reason-relay

# You also need to make sure you have Relay (experimental version) installed. NOTE: Babel and the Relay babel plugin is not needed if you only use ReasonRelay.

yarn add relay-runtime@7.0.0 relay-compiler@7.0.0 react-relay@experimental relay-config@7.0.0
```

Add ReasonRelay bindings + PPX to `bsconfig.json`.

```
...
"ppx-flags": ["reason-relay/ppx"],
"bs-dependencies": ["reason-react", "reason-relay"],
...
```

_As of now_, the Relay compiler does not natively support what we need to make it
work for emitting Reason types. Therefore, we ship a patched compiler that you can use.
It works the same way as the Relay compiler, _except_ you don't need to provide `--language`.

Add and configure a `relay.config.js`-file, and run the script via package.json like this:

```
"scripts": {
  "relay": "reason-relay-compiler"
}

yarn relay
```

You can also start the compiler in watch mode by running:
`yarn relay --watch`

## Usage

Docs are WIP, but for now you can check out the `examples` folder for a complete example of setup and usage of most features.
