#!/bin/bash

KAFKA_BROKER_IP=172.30.1.111

echo "INFO| Make 'kafka-topic' to Kafka Cluster"
kafka-topics.sh --create \
--bootstrap-server ${KAFKA_BROKER_IP}:9092 \
--topic kafka-topic
sleep 1

echo "INFO| Consume 'kafka-topic' from Kafka Cluster"
kafka-console-consumer.sh \
--bootstrap-server ${KAFKA_BROKER_IP}:9092 \
--topic kafka-topic
