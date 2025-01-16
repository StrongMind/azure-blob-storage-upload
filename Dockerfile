FROM mcr.microsoft.com/azure-cli

LABEL "com.github.actions.name"="azure-blob-storage-upload"
LABEL "com.github.actions.description"="Uploads assets to Azure Blob Storage"
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="green"
LABEL "repository"="https://github.com/bacongobbler/azure-blob-storage-upload"
LABEL "homepage"="https://github.com/bacongobbler/azure-blob-storage-upload"
LABEL "maintainer"="Matthew Fisher <matt.fisher@microsoft.com>"
RUN echo "+++++++++GETTING AZCOPY COMMAND+++++++++"
RUN ls -lal
RUN wget https://aka.ms/downloadazcopy-v10-linux -O azcopy.tar.gz \
    && tar -xvf azcopy.tar.gz --strip-components=1 -C /usr/local/bin azcopy_linux_amd64_*/azcopy \
    && rm azcopy.tar.gz

RUN azcopy --version

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
