#!/usr/bin/env bash

set -e;

# make release folder structure
rm -rf _release;
mkdir -p _release/src;

# build and copy cli
mkdir -p _release/cli;
cd packages/rescript-relay-cli;
echo "Build CLI...";
yarn; yarn build;
cp dist/index.js ../../_release/cli/cli.js;
cd ../../;

# build bindings
cd packages/rescript-relay;
echo "Build bindings...";
yarn; yarn build;

# copy bindings and readme
echo "Copying bindings and assets..."
cp -rf src ../../_release;
cp .npmignore ../../_release/;
cp ../../README.md ../../_release/;
cp ../../CHANGELOG.md ../../_release/;

# copy config files
echo "Copying config files..."
cp bsconfig.release.json ../../_release/bsconfig.json;
./copyPackageJson.js ../../_release $INPUT_TAG_NAME
cp yarn.lock ../../_release/;

# copy real post-install
cp -f scripts/release-postinstall.js ../../_release/postinstall.js
