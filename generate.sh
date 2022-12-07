#! /bin/bash

cp -f /buf/*.yaml /proto/
cd /proto
buf generate

if [ -f /proto/buf.gen.yaml ]; then
    rm -f /proto/buf.gen.yaml
fi

if [ -f /proto/buf.yaml ]; then
    rm -f /proto/buf.yaml
fi

# convert the haskell protos as well
find ./ -name "*.proto" -exec protoc --plugin=protoc-gen-haskell=`which proto-lens-protoc` --haskell_out=./gen/haskell {} \;