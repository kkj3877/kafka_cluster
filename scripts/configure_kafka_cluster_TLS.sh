#!/bin/bash

## SET YOUR INFO
ZOOKEEPER_IP=172.30.1.111
KAFKA_BROKER_IP=172.30.1.111
##############################

DOWNLOAD_DIR=~/Documents
KAFKA_HOME=${DOWNLOAD_DIR}/kafka
SH_DIR=${DOWNLOAD_DIR}/scripts

CONFIG_DIR=${KAFKA_HOME}/config
BACKUP_DIR=${KAFKA_HOME}/backup
SSL_DIR=${DOWNLOAD_DIR}/ssl
KAFKA_SSL_DIR=${KAFKA_HOME}/ssl

mkdir -p ${KAFKA_SSL_DIR}
cp -r ${DOWNLOAD_DIR}/ssl/* ${KAFKA_SSL_DIR}/

##################################################
## Configure properties file for Zookeeper
if [ ! -e ${BACKUP_DIR}/PLAIN_zookeeper.properties ];then
    echo "INFO| Make backup file: [config/zookeeper.properties] -> [backup/PLAIN_zookeeper.properties]"
    mv ${CONFIG_DIR}/zookeeper.properties ${BACKUP_DIR}/PLAIN_zookeeper.properties
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

############################# Security Options #############################
secureClientPort=2182
authProvider.x509=org.apache.zookeeper.server.auth.X509AuthenticationProvider
serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
ssl.trustStore.location=${KAFKA_SSL_DIR}/kafka.zookeeper.truststore.jks
ssl.trustStore.password=test123
ssl.keyStore.location=${KAFKA_SSL_DIR}/kafka.zookeeper.keystore.jks
ssl.keyStore.password=test123
ssl.clientAuth=need

# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0

# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
#admin.serverPort=8080" > ${CONFIG_DIR}/zookeeper.properties


##################################################
## Configure properties file for Kafka Broker
if [ ! -e ${BACKUP_DIR}/PLAIN_server.properties ];then
    echo "INFO| Make backup file: [config/server.properties] -> [backup/PLAIN_server.properties]"
    mv ${CONFIG_DIR}/server.properties ${BACKUP_DIR}/PLAIN_server.properties
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
listeners=PLAINTEXT://${KAFKA_BROKER_IP}:9092,SSL://${KAFKA_BROKER_IP}:9093
advertised.listeners=PLAINTEXT://${KAFKA_BROKER_IP}:9092,SSL://${KAFKA_BROKER_IP}:9093

num.network.threads=3
num.io.threads=8

socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

############################# Secure Settings #############################
# Properties for SSL Kafka Security between Broker and clients
ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.broker.truststore.jks
ssl.truststore.password=test123
ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.broker.keystore.jks
ssl.keystore.password=test123
ssl.key.password=test123

ssl.client.auth=required
ssl.protocol=TLSv1.2

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
zookeeper.connect=${ZOOKEEPER_IP}:2182
zookeeper.connection.timeout.ms=18000

# Properties for SSL Kafka Security between Broker and Zookeeper
zookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
zookeeper.ssl.client.enable=true
zookeeper.ssl.protocol=TLSv1.2

zookeeper.ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.broker.truststore.jks
zookeeper.ssl.truststore.password=test123
zookeeper.ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.broker.keystore.jks
zookeeper.ssl.keystore.password=test123

zookeeper.set.acl=true

############################# Group Coordinator Settings #############################
group.initial.rebalance.delay.ms=0" > ${CONFIG_DIR}/server.properties


##################################################
## Configure properties file for Kafka Connect
if [ ! -e ${BACKUP_DIR}/PLAIN_connect-distributed.properties ];then
    echo "INFO| Make backup file: [config/connect-distributed.properties] -> [backup/PLAIN_connect-distributed.properties]"
    mv ${CONFIG_DIR}/connect-distributed.properties ${BACKUP_DIR}/PLAIN_connect-distributed.properties
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
bootstrap.servers=${KAFKA_BROKER_IP}:9093

############################# Secure Settings #############################
security.protocol=SSL
ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.client.truststore.jks
ssl.truststore.password=test123
ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.client.keystore.jks
ssl.keystore.password=test123
ssl.key.password=test123
# ssl.cipher.suites = TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
# ssl.cipher.suites = TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384

producer.bootstrap.servers=172.30.1.111:9093
producer.security.protocol=SSL
producer.ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.client.truststore.jks
producer.ssl.truststore.password=test123
producer.ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.client.keystore.jks
producer.ssl.keystore.password=test123
producer.ssl.key.password=test123
# producer.ssl.cipher.suites = TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256

consumer.bootstrap.servers=172.30.1.111:9093
consumer.security.protocol=SSL
consumer.ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.client.truststore.jks
consumer.ssl.truststore.password=test123
consumer.ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.client.keystore.jks
consumer.ssl.keystore.password=test123
consumer.ssl.key.password=test123

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
plugin.path=${KAFKA_HOME}/plugins" > ${CONFIG_DIR}/connect-distributed.properties

##################################################
## Configure properties file for Kafka Consumer (for TLS)
if [ ! -e ${BACKUP_DIR}/default_consumer.properties ];then
    echo "INFO| Make backup file: [config/consumer.properties] -> [backup/default_consumer.properties]"
    mv ${CONFIG_DIR}/consumer.properties ${BACKUP_DIR}/default_consumer.properties
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
# see org.apache.kafka.clients.consumer.ConsumerConfig for more details

# list of brokers used for bootstrapping knowledge about the rest of the cluster
# format: host1:port1,host2:port2 ...
bootstrap.servers=${KAFKA_BROKER_IP}:9093

# consumer group id
# group.id=test-consumer-group

# What to do when there is no initial offset in Kafka or if the current
# offset does not exist any more on the server: latest, earliest, none
#auto.offset.reset=

############################# Secure Settings #############################
security.protocol=SSL
ssl.protocol=TLSv1.2
ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.client.truststore.jks
ssl.truststore.password=test123
ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.client.keystore.jks
ssl.keystore.password=test123
ssl.key.password=test123
" > ${CONFIG_DIR}/consumer.properties

##################################################
## Configure properties file for Kafka Consumer (for TLS)
if [ ! -e ${BACKUP_DIR}/default_producer.properties ];then
    echo "INFO| Make backup file: [config/producer.properties] -> [backup/default_producer.properties]"
    mv ${CONFIG_DIR}/producer.properties ${BACKUP_DIR}/default_producer.properties
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
# see org.apache.kafka.clients.producer.ProducerConfig for more details

############################# Producer Basics #############################

# list of brokers used for bootstrapping knowledge about the rest of the cluster
# format: host1:port1,host2:port2 ...
bootstrap.servers=${KAFKA_BROKER_IP}:9093

# specify the compression codec for all data generated: none, gzip, snappy, lz4, zstd
compression.type=none

# name of the partitioner class for partitioning events; default partition spreads data randomly
#partitioner.class=

# the maximum amount of time the client will wait for the response of a request
#request.timeout.ms=

# how long \`KafkaProducer.send\` and \`KafkaProducer.partitionsFor\` will block for
#max.block.ms=

# the producer will wait for up to the given delay to allow other records to be sent so that the sends can be batched together
#linger.ms=

# the maximum size of a request in bytes
#max.request.size=

# the default batch size in bytes when batching multiple records sent to a partition
#batch.size=

# the total bytes of memory the producer can use to buffer records waiting to be sent to the server
#buffer.memory=

############################# Secure Settings #############################
security.protocol=SSL
ssl.protocol=TLSv1.2
ssl.truststore.location=${KAFKA_SSL_DIR}/kafka.client.truststore.jks
ssl.truststore.password=test123
ssl.keystore.location=${KAFKA_SSL_DIR}/kafka.client.keystore.jks
ssl.keystore.password=test123
ssl.key.password=test123
" > ${CONFIG_DIR}/producer.properties

##################################################
## Make shell script to make MQTT source connector on Kafka-Connect
echo -e "#!/bin/bash

# MQTT 커넥터 설정 정보
CONN_NAME=mqtt-source-connector-test
MQTT_BROKERS=ssl://172.30.1.199:8883
MQTT_SSL_CA_CERT=/etc/ssl/ca-cert
MQTT_SSL_CERT=/etc/ssl/mosquitto-client-cert
MQTT_SSL_KEY=/etc/ssl/mosquitto-client-key
MQTT_TOPIC=mqtt_topic
KAFKA_TOPIC=kafka-topic

# 카프카 커넥트에 MQTT 커넥터 생성 요청
echo \"{ \\\"name\\\":\\\"\${CONN_NAME}\\\", \\\"config\\\": {
\\\"connector.class\\\":\\\"com.datamountaineer.streamreactor.connect.mqtt.source.MqttSourceConnector\\\",
\\\"tasks.max\\\": 1,
\\\"connect.mqtt.kcql\\\": \\\"INSERT INTO \${KAFKA_TOPIC} SELECT * FROM \${MQTT_TOPIC} \\
WITHCONVERTER=\\\`com.datamountaineer.streamreactor.connect.converters.source.JsonSimpleConverter\\\` WITHKEY(id)\\\",
\\\"connect.mqtt.timeout\\\" : 1000,
\\\"connect.mqtt.keep.alive\\\" : 1000,
\\\"connect.mqtt.clean\\\" : false,
\\\"connect.mqtt.client.id\\\" : \\\"kafka-connect\\\",
\\\"connect.mqtt.converter.throw.on.error\\\" : false,
\\\"connect.mqtt.hosts\\\" : \\\"\${MQTT_BROKERS}\\\",
\\\"connect.mqtt.ssl.ca.cert\\\" : \\\"\${MQTT_SSL_CA_CERT}\\\",
\\\"connect.mqtt.ssl.cert\\\" : \\\"\${MQTT_SSL_CERT}\\\",
\\\"connect.mqtt.ssl.key\\\" : \\\"\${MQTT_SSL_KEY}\\\",
\\\"connect.mqtt.service.quality\\\" : 1,
\\\"connect.mqtt.tls.version\\\" : \\\"tlsv1.2\\\",
\\\"key.converter\\\" : \\\"org.apache.kafka.connect.json.JsonConverter\\\",
\\\"key.converter.schemas.enable\\\" : false,
\\\"value.converter\\\" : \\\"org.apache.kafka.connect.json.JsonConverter\\\",
\\\"value.converter.schemas.enable\\\" : false,
\\\"errors.tolerance\\\" : \\\"all\\\",
\\\"errors.log.enable\\\" : true,
\\\"errors.log.include.messages\\\" : true
}}\" | http POST ${KAFKA_BROKER_IP}:8083/connectors

# \\\"connect.mqtt.tls.ciphers\\\" : \\\"TLS_ECDHE_RSA_AES128_GCM_SHA256\\\"," > ${KAFKA_HOME}/connect_mqtt_connector_TLS.sh
chmod 755 ${KAFKA_HOME}/connect_mqtt_connector_TLS.sh

echo "#!/bin/bash

http DELETE ${KAFKA_BROKER_IP}:8083/connectors/mqtt-source-connector-test" > ${KAFKA_HOME}/rm_connector.sh
chmod 755 ${KAFKA_HOME}/rm_connector.sh

mv ${KAFKA_HOME}/*test.sh ${BACKUP_DIR}
mv configure_kafka_cluster_TLS.sh ${BACKUP_DIR}

cp ${SH_DIR}/consumer_test_TLS.sh ${KAFKA_HOME}
cp ${SH_DIR}/producer_test_TLS.sh ${KAFKA_HOME}
