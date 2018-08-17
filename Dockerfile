
FROM maven:3.5-jdk-8 as BUILD

COPY src /usr/src/kafka-connect-elasticsearch/src
COPY config /usr/src/kafka-connect-elasticsearch/config
COPY checkstyle /usr/src/kafka-connect-elasticsearch/checkstyle
COPY licenses /usr/src/kafka-connect-elasticsearch/licenses
COPY pom.xml /usr/src/kafka-connect-elasticsearch
RUN mvn -f /usr/src/kafka-connect-elasticsearch/pom.xml clean package -P standalone

FROM confluentinc/cp-kafka-connect as kafka-connect

COPY --from=BUILD /usr/src/kafka-connect-elasticsearch/target/kafka-connect-elasticsearch-5.0.0-standalone.jar /connect-plugins/kafka-connect-elasticsearch-5.0.0-standalone.jar

ENV CONNECT_GROUP_ID connect
ENV CONNECT_CONFIG_STORAGE_TOPIC connect-config
ENV CONNECT_OFFSET_STORAGE_TOPIC connect-offsets
ENV CONNECT_STATUS_STORAGE_TOPIC connect-status
ENV CONNECT_REPLICATION_FACTOR 1
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR 1
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR 1
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR 1
ENV CONNECT_KEY_CONVERTER "org.apache.kafka.connect.storage.StringConverter"
ENV CONNECT_VALUE_CONVERTER "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE false
ENV CONNECT_INTERNAL_KEY_CONVERTER "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_INTERNAL_VALUE_CONVERTER "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_PRODUCER_INTERCEPTOR_CLASSES "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
ENV CONNECT_CONSUMER_INTERCEPTOR_CLASSES "io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor"
ENV CONNECT_PLUGIN_PATH /connect-plugins
ENV CONNECT_LOG4J_ROOT_LOGLEVEL INFO
ENV CONNECT_LOG4J_LOGGERS org.reflections=ERROR
ENV CLASSPATH /usr/share/java/monitoring-interceptors/monitoring-interceptors-3.3.0.jar




