#!/bin/bash

chmod ugo+x /usr/local/zk/startup.sh && 
mkdir -p $ZK_DATA && 
mkdir -p $ZK_DATALOG && 
mkdir -p $ZK_LOGS && 
mkdir -p $ZK_CONF &&
/bin/cp -f /usr/local/zk/conf/zoo.cfg $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^tickTime/c\tickTime=$ZK_TICK_TIME" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^initLimit/c\initLimit=$ZK_INIT_LIMIT" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^syncLimit/c\syncLimit=$ZK_SYNC_LIMIT" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^autopurge.snapRetainCount/c\autopurge.snapRetainCount=$ZK_AUTOPURGE_SNAPRETAINCOUNT" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^autopurge.purgeInterval/c\autopurge.purgeInterval=$ZK_AUTOPURGE_PURGEINTERVAL" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^maxClientCnxns/c\maxClientCnxns=$ZK_MAX_CLIENT_CNXNS" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^clientPort/c\clientPort=$ZK_PORT" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^dataDir/c\dataDir=$ZK_DATA" $ZK_CONF/zoo.cfg &&
/bin/sed -i "/^dataLogDir/c\dataLogDir=$ZK_DATALOG" $ZK_CONF/zoo.cfg &&
touch $ZK_DATA/myid && 
echo $ZK_MYID > $ZK_DATA/myid &&
if [ ! -n "$ZK_CLUSTER" ]; then
    echo "IS NULL"
else
    array=(${ZK_CLUSTER//;/ })
	for var in ${array[@]}
	do
	    echo $var >> $ZK_CONF/zoo.cfg
	done
fi
/usr/local/zk/bin/zkServer.sh start $ZK_CONF/zoo.cfg
tail -f /dev/null
 