ARG IMAGE_CA=hyperledger/fabric-ca:latest
ARG IMAGE_TOOLS=hyperledger/fabric-tools:latest

FROM ${IMAGE_CA} AS ca

FROM ${IMAGE_TOOLS}
COPY --from=ca /usr/local/bin/fabric-ca-client /usr/local/bin/