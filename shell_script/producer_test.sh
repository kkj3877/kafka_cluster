#!/bin/bash

KAFKA_BROKER_IP=172.30.1.111

echo "INFO| Produce message to 'kafka-topic'"
echo -e "INFO| Try to send '{\"id\":\"1\", \"score\":10}'"
kafka-console-producer.sh \
--bootstrap-server ${KAFKA_BROKER_IP}:9092 \
--topic kafka-topic
