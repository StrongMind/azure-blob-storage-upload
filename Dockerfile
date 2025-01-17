FROM --platform=linux/amd64 ubuntu:20.04

LABEL "com.github.actions.name"="azure-blob-storage-upload"
LABEL "com.github.actions.description"="Uploads assets to Azure Blob Storage"
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="green"
LABEL "repository"="https://github.com/bacongobbler/azure-blob-storage-upload"
LABEL "homepage"="https://github.com/bacongobbler/azure-blob-storage-upload"
LABEL "maintainer"="Matthew Fisher <matt.fisher@microsoft.com>"

RUN apt-get update
RUN apt-get install -y wget tar
RUN wget https://aka.ms/downloadazcopy-v10-linux -O azcopy.tar.gz
RUN tar -xvf azcopy.tar.gz --strip-components=1
RUN mv azcopy /usr/local/bin/

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg

RUN AZ_DIST=$(lsb_release -cs) && \
    echo "Types: deb\nURIs: https://packages.microsoft.com/repos/azure-cli/\nSuites: ${AZ_DIST}\nComponents: main\nArchitectures: $(dpkg --print-architecture)\nSigned-by: /etc/apt/keyrings/microsoft.gpg" | \
    tee /etc/apt/sources.list.d/azure-cli.sources

RUN apt-get update && apt-get -y install azure-cli

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
