#!/bin/bash
cd ../relay/compiler;
cargo build && cp -f target/debug/relay ../../rescript-relay/rescript-relay-compiler;
cd ../../rescript-relay;