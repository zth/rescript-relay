#!/usr/bin/env bash

# make release folder structure
rm -rf _release;
mkdir -p _release/src;

# build bindings
echo "Build bindings...";
cd packages/reason-relay;
yarn; yarn build;

# build language plugin
echo "Build language plugin...";
cd ./language-plugin/; yarn; yarn test; yarn build; cd ..;

# copy bindings and readme
echo "Copying bindings and assets..."
cp src/*.re* ../../_release/src/;
cp ../../README.md ../../_release/;
cp -rf src/vendor ../../_release/src/vendor;

# copy config files
echo "Copying config files..."
cp bsconfig.json ../../_release/;
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
