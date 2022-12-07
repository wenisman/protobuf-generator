#FROM node:16.18
FROM haskell:9.2.5

RUN curl -fsSL http://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update
RUN apt-get install curl -y protobuf-compiler nodejs
RUN npm install -g yarn
RUN yarn global add grpc-tools grpc_tools_node_protoc_ts
RUN curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz

# Configure Go
ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Setup protoc
RUN PROTOC_ZIP=protoc-3.20.3-linux-x86_64.zip && \
    curl -OL curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/${PROTOC_ZIP} && \
    unzip ${PROTOC_ZIP} -d /usr/local bin/protoc && \
    unzip ${PROTOC_ZIP} -d /usr/local 'include/*'

# setup Buf
RUN PREFIX="/usr/local" && \
    VERSION="1.8.0" && \
    curl -sSL \
    "https://github.com/bufbuild/buf/releases/download/v${VERSION}/buf-$(uname -s)-$(uname -m).tar.gz" | \
    tar -xvzf - -C "${PREFIX}" --strip-components 1

RUN mkdir -p /proto
RUN mkdir -p /buf

# Setup Haskell Stack
# RUN curl -sSL https://get.haskellstack.org/ | sh
# ENV PATH /usr/local/bin/stack:/root/.local/bin:$PATH
RUN stack update
RUN stack install proto-lens-protoc

WORKDIR /proto

COPY ./*.yaml /buf/
COPY ./*.sh /buf/
RUN chmod a+x /buf/*.sh

ENTRYPOINT [ "/buf/generate.sh" ]