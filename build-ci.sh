#!/usr/bin/env bash

# make release folder structure
rm -rf _release;
mkdir -p _release/src;

# build language plugin
echo "Build language plugin...";
cd packages/reason-relay/language-plugin/; yarn; yarn test; yarn build; cd ..;

# build bindings
echo "Build bindings...";
yarn; yarn build; yarn test;

# copy bindings and readme
echo "Copying bindings and assets..."
cp src/* ../../_release/src/;
cp .npmignore ../../_release/;
cp ../../README.md ../../_release/;
cp -rf src/vendor ../../_release/src/vendor;

# copy config files
echo "Copying config files..."
cp bsconfig.release.json ../../_release/bsconfig.json;
cp package.json ../../_release/;
cp yarn.lock ../../_release/;

# copy real post-install
cp -f scripts/release-postinstall.js ../../_release/postinstall.js

# copy language plugin
echo "Copying language plugin..."
cp -r ./language-plugin/dist ../../_release/language-plugin;

# copy compiler
echo "Copying compiler..."
cp -r ./compiler/ ../../_release/compiler;
