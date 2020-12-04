#!/usr/bin/env bash
# Build SSVM-Storage dependencies
cd ./rust_native_storage_library/
make target/debug/librust_native_storage_library.so
cd ../

# Check TensorFlow version
c++ ./utils/checker/tensorflow_version_checker.cc -ltensorflow -o ./tf_ver
./tf_ver
if [ "$?" -eq "0" ]
then
  rm ./tf_ver
  exit 0
else
  echo "TensorFlow C library is not yet installed or is too old to support"
  exit 1
fi
