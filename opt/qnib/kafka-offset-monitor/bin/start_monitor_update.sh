#!/usr/local/dumb-init /bin/bash

if [ "X${ZK_DC}" != "X" ];then
    sed -i'' -E "s#service \"zookeeper(@\w+)?\"#service \"zookeeper@${ZK_DC}\"#" /etc/consul-templates/zkui.conf.ctmpl
fi

consul-template -consul localhost:8500 -template "/etc/consul-templates/start_monitor.sh.ctmpl:/opt/qnib/kafka-offset-monitor/bin/start_monitor.sh: chmod +x /opt/qnib/kafka-offset-monitor/bin/start_monitor.sh; supervisorctl restart kafka-offset-monitor"

