#!/bin/sh

PWD=`pwd`

OSGI=/usr/osgi
FRAMEWORK=$OSGI/felix-framework
BUNDLE=$FRAMEWORK/bundle
CONF=$FRAMEWORK/conf/config.properties
CONF_backup="${CONF}.backup"
MACH_ID=`ip link show eth0 | grep ether | awk '{print $2}'` #`cat /sys/class/net/eth0/address`

##### Files
PLUGIN_FILES=`ls *.jar`
# PLUGIN_hproxy="com.chinatelecom.smartgateway.hproxy.jar"
# PLUGIN_hproxy="com.chinatelecom.smartgateway.hproxy-1.0.0.jar"

##### Functions
stop_jamvm()
{
    killall cfg_manager
    killall jamvm
}

start_jamvm()
{
    cd $FRAMEWORK
    rm /tmp/felix-cache -fr
    ../bin/jamvm -Dfile.encoding=UTF-8 \
        -Dfelix.config.properties=file:$CONF \
        -Xms64M -Xss1M -Xmx128M -jar bin/felix.jar
}
##### END Functions


##### setup files
# cp $PLUGIN_hproxy $BUNDLE/
for plugin in $PLUGIN_FILES;
do
    # create link, remove versoin sub string;
    link=`echo $plugin | awk -F - '{print $1}'`
    ln -sf "$PWD/$plugin" "$BUNDLE/${link}.jar"
    # DEBUG
    echo "Found hotfix plugin: $plugin -> ${link}.jar"
done
ln -sf $PWD/$PLUGIN_hproxy_file $BUNDLE/$PLUGIN_hproxy

##### update config
[ -f $CONF_backup ] || cp $CONF $CONF_backup
sed -r 's#mangement\.jar#mangement.jar \\\n file:bundle/com.chinatelecom.smartgateway.hproxy.jar#g' <  $CONF_backup > $CONF
echo "com.chinatelecom.smartgateway.hproxy.id=$MACH_ID" >> $CONF

##### restart jamvm
stop_jamvm
start_jamvm


