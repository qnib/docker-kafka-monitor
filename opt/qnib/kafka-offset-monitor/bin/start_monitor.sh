#!/bin/bash

function check_zookeeper {
    DC_QUERY=""
    if [ "X${ZK_DC}" != "X" ];then
       DC_QUERY="?dc=${ZK_DC}"
    fi
    cnt_zk=$(curl -s "localhost:8500/v1/catalog/service/zookeeper${DC_QUERY}"|grep -c "Node")
    if [ ${cnt_zk} -ne 1 ];then
        echo "[start_kafka-offset] No running 'zookeeper service yet, sleep 5 sec'"
        sleep 5
        check_zookeeper
    fi
}
check_zookeeper
sleep 5
ZK_HOSTS=zookeeper.service.consul
if [ "X${ZK_DC}" != "X" ];then
    ZK_HOSTS=zookeeper.service.${ZK_DC}.consul
fi
java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk ${ZK_HOSTS} \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days
