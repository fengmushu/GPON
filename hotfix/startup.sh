#!/bin/sh

PWD=`pwd`

OSGI=/usr/osgi/
FRAMEWORK=$OSGI/felix-framework
BUNDLE=$FRAMEWORK/bundle
CONF=$FRAMEWORK/conf/config.properties
CONF_backup="${CONF}.backup"
PLUGIN=com.chinatelecom.smartgateway.hproxy.jar


stop_jamvm()
{
    killall cfg_manager
    killall jamvm
}

start_jamvm()
{
    cd $FRAMEWORK
    rm /tmp/felix-cache -fr
    ../bin/jamvm -Dfile.encoding=UTF-8 -Xms64M -Xss1M -Xmx128M -jar bin/felix.jar
}


##### setup files
# cp $PLUGIN $BUNDLE/
ln -sf $PWD/$PLUGIN $BUNDLE/$PLUGIN 

##### update config
[ -f $CONF_backup ] || cp $CONF $CONF_backup
sed -r 's#mangement\.jar#mangement.jar \\\r\n file:bundle\/com.chinatelecom.smartgateway.hproxy.jar#g' <  $CONF_backup > $CONF

##### restart jamvm
stop_jamvm
start_jamvm


