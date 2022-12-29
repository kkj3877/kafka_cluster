#!/bin/bash

./scripts/explode_kafka.sh

SCALA_VER=2.12
KAFKA_VER=2.5.0
DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka_${SCALA_VER}-${KAFKA_VER}
SH_DIR=${DOWNLOAD_DIR}/scripts

echo -n "Info| Unzip kafka"
tar xzf ${KAFKA_HOME}.tgz -C ${DOWNLOAD_DIR}
echo " -> Complete."
ln -s ${KAFKA_HOME} ${DOWNLOAD_DIR}/kafka
echo -e "Info| Directory \"kafka\" is the simbolic link."

cp ${SH_DIR}/configure_kafka_cluster.sh ./kafka/

cd ${KAFKA_HOME}
mkdir -p ./data/zookeeper ./data/broker ./logs ./backup ./plugins
