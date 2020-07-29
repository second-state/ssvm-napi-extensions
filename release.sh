./preinstall.sh
CXX=g++-9 node-pre-gyp install --fallback-to-build --update-binary
rm -rf tmp/ssvm-storage
mkdir -p tmp/ssvm-storage
cp build/Release/ssvm-storage.node tmp/ssvm-storage
strip tmp/ssvm-storage/ssvm-storage.node
cd tmp/
tar zcvf ../ssvm-storage-linux-x64.tar.gz ssvm-storage
cd ../
