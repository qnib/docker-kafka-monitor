#!/usr/local/bin/dumb-init /bin/bash
#!/bin/bash

function check_zookeeper {
    DC_QUERY=""
    cnt_zk=$(curl -s "localhost:8500/v1/catalog/service/zookeeper${DC_QUERY}"|grep -c "Node")
    if [ ${cnt_zk} -ne 1 ];then
        echo "[start_kafka-offset] No running 'zookeeper service yet, sleep 5 sec'"
        sleep 5
        check_zookeeper
    fi
}
if [ "X${ZK_HOSTS}" == "X" ];then
  check_zookeeper
  sleep 5
  ZK_HOSTS=zookeeper.consul.service
fi

java -cp KafkaOffsetMonitor-assembly-${KAFKA_MONITOR_VER}${KAFKA_MONITOR_SUFFIX}.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --offsetStorage ${KAFKA_MONITOR_OFFSET_STORAGE} \
     --zk ${ZK_HOSTS} \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days
