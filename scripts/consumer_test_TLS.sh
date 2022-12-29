#!/bin/bash

DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka
CONFIG_DIR=${KAFKA_HOME}/config

KAFKA_BROKER_IP=172.30.1.111

echo "INFO| Consume 'kafka-topic' from Kafka Cluster"
kafka-console-consumer.sh \
--bootstrap-server ${KAFKA_BROKER_IP}:9093 \
--topic kafka-topic \
--consumer.config ${CONFIG_DIR}/consumer.properties
