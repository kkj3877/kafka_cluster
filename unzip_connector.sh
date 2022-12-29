#!/bin/bash

DOWNLOAD_DIR=/home/cluster/Documents
DOWNLOAD_FILE=stream-reactor-2.1.3.tar.gz
UNZIP_DIR=stream-reactor-2.1.3

tar -xzf ${DOWNLOAD_DIR}/${DOWNLOAD_FILE} -C ${DOWNLOAD_DIR}

echo -e "#!/bin/bash

KAFKA_PLUGIN_DIR=${DOWNLOAD_DIR}/kafka/plugins
STREAM_REACTOR_HOME=${DOWNLOAD_DIR}/${UNZIP_DIR}
MQTT_LIB_DIR=\${STREAM_REACTOR_HOME}/kafka-connect-mqtt/build/libs
MQTT_CONNECTOR_LIB=kafka-connect-mqtt-2.1.3-2.5.0-all.jar

./gradlew :kafka-connect-mqtt:shadowJar

mkdir -p ${KAFKA_PLUGIN_DIR}
cp \${MQTT_LIB_DIR}/\${MQTT_CONNECTOR_LIB} \${STREAM_REACTOR_HOME}
cp \${MQTT_LIB_DIR}/\${MQTT_CONNECTOR_LIB} \${KAFKA_PLUGIN_DIR}" > ${UNZIP_DIR}/make.sh
chmod 755 ${UNZIP_DIR}/make.sh
