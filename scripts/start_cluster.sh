#!/bin/bash

echo "Wait seconds to start Zookeeper..."
zookeeper-server-start.sh -daemon /home/cluster/Documents/kafka/config/zookeeper.properties
sleep 2s
echo "Wait seconds to start Kafka Broker..."
kafka-server-start.sh -daemon /home/cluster/Documents/kafka/config/server.properties
sleep 1s
echo "Done"
