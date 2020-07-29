#!/usr/bin/env bash
cd ./rust_native_storage_library/
make
cp ./rust_native_storage_library/target/debug/librust_native_storage_library.so ./librust_native_storage_library.so
