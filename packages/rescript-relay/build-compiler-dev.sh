#!/bin/bash
cd ../relay/compiler;
cargo build && cp -f target/debug/relay ../../rescript-relay/relay-compiler;
cd ../../rescript-relay;