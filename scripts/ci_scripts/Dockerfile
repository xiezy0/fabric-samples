ARG IMAGE_CA=twblockchain/fabric-ca:latest
ARG IMAGE_TOOLS=twblockchain/fabric-tools:latest

FROM ${IMAGE_CA} AS ca

FROM ${IMAGE_TOOLS}
COPY --from=ca /usr/local/bin/fabric-ca-client /usr/local/bin/