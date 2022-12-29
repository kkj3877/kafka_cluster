#!/bin/bash

KAFKA_URL=https://archive.apache.org/dist/kafka
SCALA_VER=2.12
KAFKA_VER=2.5.0
DOWNLOAD_FILE=kafka_${SCALA_VER}-${KAFKA_VER}.tgz
DOWNLOAD_DIR=~/Documents
SH_DIR=${DOWNLOAD_DIR}/scripts

## Download Kafka.tgz file
if [ ! -e ${KAFKA_URL}/${KAFKA_VER}/${DOWNLOAD_FILE} ]; then
    wget -d -P ${DOWNLOAD_DIR} ${KAFKA_URL}/${KAFKA_VER}/${DOWNLOAD_FILE}
    wget -d -P ${DOWNLOAD_DIR} ${KAFKA_URL}/${KAFKA_VER}/${DOWNLOAD_FILE}.asc
    wget -d -P ${DOWNLOAD_DIR} ${KAFKA_URL}/${KAFKA_VER}/${DOWNLOAD_FILE}.sha512
    echo -e ">> Download Complete.\n"

    ## Verify the integrity
    cd ${DOWNLOAD_DIR}
    # gpg --import ${DOWNLOAD_FILE}.asc
    gpg --verify ${DOWNLOAD_FILE}.asc ${DOWNLOAD_FILE}

    echo -e "\n[ Calculated Hash Value ]"
    gpg --print-md SHA512 ${DOWNLOAD_FILE}

    echo "[ Known Hash Value ]"
    cat ${DOWNLOAD_FILE}.sha512

    rm ${DOWNLOAD_FILE}.*
else
    echo -e ">> kafka.tgz file exists already."
fi

## Unzip kafka.tgz
tar xzf ${DOWNLOAD_FILE} ${DOWNLOAD_DIR}
ln -s kafka_${SCALA_VER}-${KAFKA_VER} kafka
echo -e "Info| Directory \"kafka\" is the simbolic link."

cp ${SH_DIR}/configure_kafka_cluster.sh ./kafka/

## Make some directory using while running kafka cluster
cd ./kafka/
mkdir -p ./data/zookeeper ./data/broker ./logs ./backup ./plugins
