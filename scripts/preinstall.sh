#!/usr/bin/env bash

INSTALL_DIR=/usr/local
INSTALL_SCRIPT=/tmp/install_script.sh
TMP_DIR=/tmp/wasmedge
mkdir -p "$TMP_DIR"
sudo ldconfig

# Install WasmEdge
if [ -z "$(ldconfig -p | grep libwasmedge_c.so)" ]
then
  wget -O "$INSTALL_SCRIPT" https://github.com/second-state/WasmEdge-go/releases/download/v0.8.1/install_wasmedge.sh
  sudo sh "$INSTALL_SCRIPT" "$INSTALL_DIR"
  rm -f "$INSTALL_SCRIPT"
fi

# Install WasmEdge-tensorflow
if [ -z "$(ldconfig -p | grep libtensorflow.so)" ]
then
  wget -O "$INSTALL_SCRIPT" https://github.com/second-state/WasmEdge-go/releases/download/v0.8.1/install_wasmedge_tensorflow_deps.sh
  sudo sh "$INSTALL_SCRIPT" "$INSTALL_DIR"
  rm -f "$INSTALL_SCRIPT"
fi

if [ -z "$(ldconfig -p | grep libwasmedge-tensorflow_c.so)" ]
then
  wget -O "$INSTALL_SCRIPT" https://github.com/second-state/WasmEdge-go/releases/download/v0.8.1/install_wasmedge_tensorflow.sh
  sudo sh "$INSTALL_SCRIPT" "$INSTALL_DIR"
  rm -f "$INSTALL_SCRIPT"
fi

# Install WasmEdge-image
if [ -z "$(ldconfig -p | grep libpng)" -o -z "$(ldconfig -p | grep libjpeg)" ]
then
  wget -O "$INSTALL_SCRIPT" https://github.com/second-state/WasmEdge-go/releases/download/v0.8.2/install_wasmedge_image_deps.sh
  sudo sh "$INSTALL_SCRIPT" "$INSTALL_DIR"
  rm -f "$INSTALL_SCRIPT"
fi

if [ -z "$(ldconfig -p | grep libwasmedge-image_c.so)" ]
then
  wget -O "$INSTALL_SCRIPT" https://github.com/second-state/WasmEdge-go/releases/download/v0.8.2/install_wasmedge_image.sh
  sudo sh "$INSTALL_SCRIPT" "$INSTALL_DIR"
  rm -f "$INSTALL_SCRIPT"
fi

# Install WasmEdge-storage
if [ -z "$(ldconfig -p | grep libwasmedge-storage_c.so)" ]
then
  wget https://github.com/second-state/WasmEdge-storage/releases/download/0.8.1/WasmEdge-storage-0.8.1-Linux_x86_64.tar.gz
  tar -C "$TMP_DIR" -xzf WasmEdge-storage-0.8.1-Linux_x86_64.tar.gz
  sudo mv "$TMP_DIR"/include/* "$INSTALL_DIR"/include
  sudo mv "$TMP_DIR"/lib/* "$INSTALL_DIR"/lib
  rm -f WasmEdge-storage-0.8.1-Linux_x86_64.tar.gz
  rm -rf "$TMP_DIR"/*
fi

sudo ldconfig
rm -rf "$TMP_DIR"
