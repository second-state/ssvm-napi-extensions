#!/usr/bin/env bash
# Check TensorFlow version
c++ ./utils/checker/tensorflow_version_checker.cc -ltensorflow -o ./tf_ver
./tf_ver
if [ "$?" -eq "0" ]
then
  rm ./tf_ver
  exit 0
else
  echo "Error: TensorFlow C library is not yet installed or is too old to support"
  exit 1
fi

# Check libjpeg-dev and libpng-dev
ldconfig -p | grep libjpeg
if [ "$?" -eq "0" ]
then
  exit 0
else
  echo "Error: libjpeg-dev is not installed"
  exit 1
fi

ldconfig -p | grep libpng
if [ "$?" -eq "0" ]
then
  exit 0
else
  echo "Error: libpng-dev is not installed"
  exit 1
fi
