#!/bin/bash

SOURCE_URL=https://github.com/lensesio/stream-reactor/archive/refs/tags/2.1.3.tar.gz
DOWNLOAD_DIR=~/Documents
DOWNLOAD_FILE=stream-reactor-2.1.3.tar.gz

## Download stream-reactor.tar.gz file
if [ ! -e ${DOWNLOAD_FILE} ]; then
    wget -d -P ${DOWNLOAD_DIR} ${SOURCE_URL}
    mv 2.1.3.tar.gz ${DOWNLOAD_FILE}
    echo ">> Download Complete."
else
    echo ">> stream-reactor.tar.gz file exists already."
fi

## Unzip stream-reactor.tgz
echo "#!/bin/bash

DOWNLOAD_DIR=${DOWNLOAD_DIR}
DOWNLOAD_FILE=${DOWNLOAD_FILE}

tar -xzf ${DOWNLOAD_DIR}/${DOWNLOAD_FILE} -C ${DOWNLOAD_DIR}" > unzip_connector.sh
chmod 755 unzip_connector.sh
