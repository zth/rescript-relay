# Developing `rescript-relay` locally

`rescript-relay` is made up of these parts:

## Full integration tests

First thing's first - there's a suite of integration tests inside of `/packages/rescript-relay/__tests__`. The ambition is that these tests should _cover everything needed to ensure RescriptRelay is working as intended_. This includes the bindings, the language plugin and the PPX - everything. You run them by doing `yarn test` in `/packages/rescript-relay`.

Any feature added or fix done should consider whether that case is covered in the integration tests, and add tests for it if possible.

**Please note** that testing your local changes with the integration tests requires some recompiling. There's information on how to do that for each individual part below.

## The ReScript bindings and utils

`/packages/rescript-relay/src` contains all the _ReScript_ code shipped in the package. You build it by running `yarn build` in `/packages/rescript-relay`.

`bsconfig.json` is only used for development, the actual `bsconfig.json` that'll be copied to the published package is located in `bsconfig.release.json`. This setup isn't great and it's likely that we'll move to using the same `bsconfig.json` for dev and release, with a script stripping unwanted things from the config before copying it to the release bundle.

## The PPX

The PPX is located in `/packages/rescript-relay/rescript-relay-ppx` and is built with `esy`. There are a few tests for the PPX located in `/packages/rescript-relay/rescript-relay-ppx/test/TestFile.re`.

### Developing the PPX

Ensure you have `esy` installed by running `npm install -g esy`. Go to `/packages/rescript-relay/rescript-relay-ppx` and run `esy`. This will take some time as it bootstraps and compiles the project. After this finishes, the PPX will be built, and the relevant file will be located at `/packages/rescript-relay/rescript-relay-ppx/_build/default/bin/RescriptRelayPpxApp.exe`.

### Testing with the integration tests

If you want to test your changes to the PPX using the integration tests, run `esy` in the PPX folder to build the PPX, and then run `yarn rescript clean && yarn build && yarn test` in `/packages/rescript-relay`. This will clean and rebuild the tests before running them, ensuring that your changes to the PPX is picked up.

### Tests

The language plugin has a fairly comprehensive test suite that can be run by doing `yarn test`. The tests are sadly mostly snapshot tests, which can make them a bit hard to decipher, but as of now that's the way I felt has given the most "bang for the buck".

### Building

You can build the language plugin in full by running `yarn build` in the root folder of the language plugin. This will build and bundle the plugin. Remember that you need to build `rescript-relay-bin` first though so there's a type gen binary available.

## Testing with the integration tests

It's a good idea to run the full integration tests after changing the language plugin. You can do that by first building the language plugin as described above, and then run `yarn build:test` in `/packages/rescript-relay`. It'll show an error message, _but that's fine_ (and expected).

Running `yarn build:test` will rerun the Relay compiler for the integration test suite using the newly built plugin. After that runs, you can run `yarn test` in `/packages/rescript-relay/` again to run the integration tests with the changes you made.

## Documentation

The docs are located in `/rescript-relay-documentation`. It's built with Docusaurus, and to develop locally you simply do `yarn && yarn start` in that folder. Currently only @zth can do the prod release of this as it's tied to his `now.sh` account, but this may change in the future.

## Release

Releases are done automatically via an on-demand workflow in GitHub Actions.
