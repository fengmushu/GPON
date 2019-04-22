#!/bin/sh

PWD=/usr/osgi

usage()
{
    echo "$0 <init> <osgi> <debug>"
    echo "    init: update config, restart tftp"
    echo "    osgi: restart osgi services"
    exit 
}

restart_ftpd()
{
    killall bftpd
    bftpd -d
}

stop_jamvm()
{
    killall cfg_manager
    killall jamvm
}

start_jamvm()
{
    cd ${PWD}/felix-framework
    rm /tmp/felix-cache -fr
    ../bin/jamvm -Dfile.encoding=UTF-8 -Xms64M -Xss1M -Xmx128M -jar bin/felix.jar
}

update_conf()
{
    cp ${PWD}/backup/* /etc
}

case $1 in
    init)
        update_conf
        restart_ftpd
    ;;
    osgi)
        stop_jamvm
        start_jamvm
    ;;
    *)
    usage
    ;;
esac
