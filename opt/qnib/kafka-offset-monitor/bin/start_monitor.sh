#!/bin/bash

function check_zookeeper {
    cnt_zk=$(curl -s localhost:8500/v1/catalog/service/zookeeper|grep -c "Node")
    if [ ${cnt_zk} -ne 1 ];then
        echo "[start_kafka-offset] No running 'zookeeper service yet, sleep 5 sec'"
        sleep 5
        check_zookeeper
    fi
}
check_zookeeper

java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk zookeeper.service.consul \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days
