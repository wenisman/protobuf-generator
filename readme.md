# Protobuf Generator

## Purpose 
This is a docker container that can be used to compile the gRPC `.proto` files into the required services and clients. 

## Supported languages
Currently the supported languages are
- golang
- java
- node JS / Typescript
- .Net C#
- Haskell

## Using
### Building the container
Make sure you have docker installed

```
docker buildx build --platform linux/amd64,linux/arm64 -t wenisman/protobuf-generator .
```

### Running
The container has a folder `/proto` that is to be used for the compilation of your proto files. To use this container mount the volume 

```
docker run -v $PWD/proto:/proto wenisman/protobuf-generator
```

The compiled files will be placed in the `/proto/gen/[language]` folder.