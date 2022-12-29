#!/bin/bash

SCALA_VER=2.12
KAFKA_VER=2.5.0
DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka_${SCALA_VER}-${KAFKA_VER}

echo "INFO| Remove kafka"
rm ${DOWNLOAD_DIR}/kafka
rm -rf ${KAFKA_HOME}
