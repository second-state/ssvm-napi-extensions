#!/usr/bin/env bash
# Build SSVM-Storage dependencies
cd ./rust_native_storage_library/
make target/debug/librust_native_storage_library.so
cd ../
