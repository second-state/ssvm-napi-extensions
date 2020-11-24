./preinstall.sh
CXX=g++-9 node-pre-gyp install --fallback-to-build --update-binary
rm -rf tmp/ssvm-extensions
mkdir -p tmp/ssvm-extensions
cp build/Release/ssvm-extensions.node tmp/ssvm-extensions
strip tmp/ssvm-extensions/ssvm-extensions.node
cd tmp/
tar zcvf ../ssvm-extensions-linux-x64.tar.gz ssvm-extensions
cd ../
