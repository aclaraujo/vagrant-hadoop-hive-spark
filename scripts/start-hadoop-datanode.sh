#!/bin/bash

source "/vagrant/scripts/common.sh"

function startDaemons {
    echo "starting Hadoop daemons"
    #$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF --script hdfs start namenode
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF --script hdfs start datanode
    #$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start resourcemanager --config $HADOOP_CONF 
    #$HADOOP_YARN_HOME/sbin/yarn-daemons.sh start nodemanager --config $HADOOP_CONF 
    #$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF
    #$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF

    echo "listing all Java processes"
    jps
}

startDaemons
