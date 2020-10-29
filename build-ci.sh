#!/usr/bin/env bash

set -e;

# make release folder structure
rm -rf _release;
mkdir -p _release/src;

# build language plugin
echo "Build language plugin...";
cd packages/reason-relay/language-plugin/; yarn; yarn build; cd ..;

# build bindings
echo "Build bindings...";
yarn; yarn build;

# copy bindings and readme
echo "Copying bindings and assets..."
cp -rf src ../../_release;
cp .npmignore ../../_release/;
cp ../../README.md ../../_release/;
cp ../../CHANGELOG.md ../../_release/;
rm ../../_release/src/*.bs.js;

# copy config files
echo "Copying config files..."
cp bsconfig.release.json ../../_release/bsconfig.json;
./copyPackageJson.js ../../_release $INPUT_TAG_NAME
cp yarn.lock ../../_release/;

# copy real post-install
cp -f scripts/release-postinstall.js ../../_release/postinstall.js

# copy language plugin
echo "Copying language plugin..."
cp -r ./language-plugin/dist ../../_release/language-plugin;

# copy compiler
echo "Copying compiler..."
cp -r ./compiler/ ../../_release/compiler;
