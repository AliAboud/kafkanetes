# Kafka and Zookeeper

FROM java:openjdk-8-jre

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.9.0.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV ADVERTISED_HOST 172.18.0.22
ENV ADVERTISED_PORT 9092


ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
# Install Kafka, Zookeeper and other needed things
RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    chmod 777 /usr/bin/start-kafka.sh



# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092 2888 3888

CMD ["supervisord", "-n"]




#######################From Docker file in repository Kafkanetes############################
#COPY zookeeper-server-start-multiple.sh /opt/kafka/bin/
#RUN chmod -R a=u /opt/kafka
#WORKDIR /opt/kafka
#VOLUME /tmp/kafka-logs /tmp/zookeeper
#EXPOSE 2181 2888 3888 9092
############################################################################################