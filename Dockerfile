###### grafana images
FROM qnib/java7

RUN curl -Ls -o /opt/KafkaOffsetMonitor-assembly-0.2.1.jar \
         https://github.com/quantifind/KafkaOffsetMonitor/releases/download/v0.2.1/KafkaOffsetMonitor-assembly-0.2.1.jar
ADD etc/supervisord.d/kafka-offset-monitor.ini /etc/supervisord.d/
ADD opt/qnib/kafka-offset-monitor/bin/ /opt/qnib/kafka-offset-monitor/bin/
ADD etc/consul.d/kafka-offset-monitor.json /etc/consul.d/