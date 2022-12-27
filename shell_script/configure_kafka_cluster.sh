#!/bin/bash

## SET YOUR INFO
ZOOKEEPER_IP=172.30.1.111
KAFKA_BROKER_IP=172.30.1.111
##############################

DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka
SH_DIR=${DOWNLOAD_DIR}/shell_script

CONFIG_DIR=${KAFKA_HOME}/config
BACKUP_DIR=${KAFKA_HOME}/backup

##################################################
## Configure properties file for Zookeeper
if [ ! -e ${BACKUP_DIR}/default_zookeeper.properties ];then
    echo "INFO| Make backup file: [config/zookeeper.properties] -> [backup/default_zookeeper.properties]"
    mv ${CONFIG_DIR}/zookeeper.properties ${BACKUP_DIR}/default_zookeeper.properties
fi

echo "# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# the directory where the snapshot is stored.
dataDir=${KAFKA_HOME}/data/broker

# the port at which the clients will connect
clientPort=2181

# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0

# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
#admin.serverPort=8080" > ${CONFIG_DIR}/zookeeper.properties


##################################################
## Configure properties file for Kafka Broker
if [ ! -e ${BACKUP_DIR}/default_server.properties ];then
    echo "INFO| Make backup file: [config/server.properties] -> [backup/default_server.properties]"
    mv ${CONFIG_DIR}/server.properties ${BACKUP_DIR}/default_server.properties
fi

echo -e "# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the \"License\"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an \"AS IS\" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################
broker.id=1

############################# Socket Server Settings #############################
listeners=PLAINTEXT://${KAFKA_BROKER_IP}:9092
advertised.listeners=PLAINTEXT://${KAFKA_BROKER_IP}:9092

num.network.threads=3
num.io.threads=8

socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

############################# Log Basics #############################
log.dirs=${KAFKA_HOME}/data/broker
num.partitions=1
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################
#log.flush.interval.messages=10000
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################
log.retention.hours=168
#log.retention.bytes=1073741824
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

############################# Zookeeper #############################
zookeeper.connect=${ZOOKEEPER_IP}:2181
zookeeper.connection.timeout.ms=18000

############################# Group Coordinator Settings #############################
group.initial.rebalance.delay.ms=0" > ${CONFIG_DIR}/server.properties


##################################################
## Configure properties file for Kafka Connect
if [ ! -e ${BACKUP_DIR}/default_connect-distributed.properties ];then
    echo "INFO| Make backup file: [config/connect-distributed.properties] -> [backup/default_connect-distributed.properties]"
    mv ${CONFIG_DIR}/connect-distributed.properties ${BACKUP_DIR}/default_connect-distributed.properties
fi

echo -e "##
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the \"License\"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an \"AS IS\" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# This file contains some of the configurations for the Kafka Connect distributed worker. This file is intended
# to be used with the examples, and some settings may differ from those used in a production system, especially
# the \`bootstrap.servers\` and those specifying replication factors.

# A list of host/port pairs to use for establishing the initial connection to the Kafka cluster.
bootstrap.servers=${KAFKA_BROKER_IP}:9092

# unique name for the cluster, used in forming the Connect cluster group. Note that this must not conflict with consumer group IDs
group.id=kafka-connect-cluster

# The converters specify the format of data in Kafka and how to translate it into Connect data. Every Connect user will
# need to configure these based on the format they want their data in when loaded from or stored into Kafka
key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter
# Converter-specific settings can be passed in by prefixing the Converter's setting with the converter we want to apply
# it to
key.converter.schemas.enable=false
value.converter.schemas.enable=false

# Topic to use for storing offsets. This topic should have many partitions and be replicated and compacted.
# Kafka Connect will attempt to create the topic automatically when needed, but you can always manually create
# the topic before starting Kafka Connect if a specific topic configuration is needed.
# Most users will want to use the built-in default replication factor of 3 or in some cases even specify a larger value.
# Since this means there must be at least as many brokers as the maximum replication factor used, we'd like to be able
# to run this example on a single-broker cluster and so here we instead set the replication factor to 1.
offset.storage.topic=connect-offsets
offset.storage.replication.factor=1
offset.storage.partitions=25

# Topic to use for storing connector and task configurations; note that this should be a single partition, highly replicated,
# and compacted topic. Kafka Connect will attempt to create the topic automatically when needed, but you can always manually create
# the topic before starting Kafka Connect if a specific topic configuration is needed.
# Most users will want to use the built-in default replication factor of 3 or in some cases even specify a larger value.
# Since this means there must be at least as many brokers as the maximum replication factor used, we'd like to be able
# to run this example on a single-broker cluster and so here we instead set the replication factor to 1.
config.storage.topic=connect-configs
config.storage.replication.factor=1

# Topic to use for storing statuses. This topic can have multiple partitions and should be replicated and compacted.
# Kafka Connect will attempt to create the topic automatically when needed, but you can always manually create
# the topic before starting Kafka Connect if a specific topic configuration is needed.
# Most users will want to use the built-in default replication factor of 3 or in some cases even specify a larger value.
# Since this means there must be at least as many brokers as the maximum replication factor used, we'd like to be able
# to run this example on a single-broker cluster and so here we instead set the replication factor to 1.
status.storage.topic=connect-status
status.storage.replication.factor=1
status.storage.partitions=5

# Flush much faster than normal, which is useful for testing/debugging
offset.flush.interval.ms=10000

# These are provided to inform the user about the presence of the REST host and port configs 
# Hostname & Port for the REST API to listen on. If this is set, it will bind to the interface used to listen to requests.
#rest.host.name=
rest.port=8083

# The Hostname & Port that will be given out to other workers to connect to i.e. URLs that are routable from other servers.
#rest.advertised.host.name=
#rest.advertised.port=

# Set to a list of filesystem paths separated by commas (,) to enable class loading isolation for plugins
# (connectors, converters, transformations). The list should consist of top level directories that include 
# any combination of: 
# a) directories immediately containing jars with plugins and their dependencies
# b) uber-jars with plugins and their dependencies
# c) directories immediately containing the package directory structure of classes of plugins and their dependencies
# Examples: 
# plugin.path=/usr/local/share/java,/usr/local/share/kafka/plugins,/opt/connectors,
#plugin.path= " > ${CONFIG_DIR}/connect-distributed.properties

cp ${SH_DIR}/start_cluster.sh ${KAFKA_HOME}
cp ${SH_DIR}/topic_test.sh ${KAFKA_HOME}
cp ${SH_DIR}/producer_test.sh ${KAFKA_HOME}
cp ${SH_DIR}/start_connect_distributed.sh ${KAFKA_HOME}
cp ${SH_DIR}/configure_kafka_cluster_TLS.sh ${KAFKA_HOME}

mv ${KAFKA_HOME}/configure_kafka_cluster.sh ${BACKUP_DIR}/
