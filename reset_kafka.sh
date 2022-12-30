#!/bin/bash

SCALA_VER=2.12
KAFKA_VER=2.5.0

DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka_${SCALA_VER}-${KAFKA_VER}
SIMBOLIC_DIR=${DOWNLOAD_DIR}/kafka
SH_DIR=${DOWNLOAD_DIR}/scripts

if [ -d ${KAFKA_HOME} ]; then
    echo "INFO| Remove kafka"
    rm ${DOWNLOAD_DIR}/kafka
    rm -rf ${KAFKA_HOME}
fi

echo -n "Info| Unzip kafka"
tar xzf ${KAFKA_HOME}.tgz -C ${DOWNLOAD_DIR}
echo " -> Complete."
ln -s ${KAFKA_HOME} ${SIMBOLIC_DIR}
echo -e "Info| Directory \"kafka\" is the simbolic link."

cp ${SH_DIR}/configure_kafka_cluster.sh ${SIMBOLIC_DIR}/

cd ${KAFKA_HOME}
mkdir -p ./data/zookeeper ./data/broker ./logs ./backup ./plugins
