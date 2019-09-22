#!/bin/sh

# set -x

PWD=`pwd`
# KVER=`uname  -r`
KVER='3.4.113+'

DEBS_DIR="/var/cache/apt/archives/"
DEBS_LIST="watchdog_5.14-3ubuntu0.16.04.1_armhf.deb"

copy_files() {
    # stop evtest-h3
    sudo killall evtest-h3

    # do copy
    cd $PWD
    sudo cp -a ./fakeroot/* /
}

do_hotfix() {
    # fixup timezone
    sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # fixup modules dir
    cd /lib/modules && {
        [ -d $KVER ] || [ -L $KVER ] || sudo ln -s 3.4.113-sun8i $KVER
    }
    sudo depmod

    # install debs
    # /var/cache/apt/archives/watchdog_5.14-3ubuntu0.16.04.1_armhf.deb
    for deb in $DEBS_LIST
    do
        sudo apt-get install -y ${DEBS_DIR}/$deb
    done

    # update watchdog conf
    sed 's/#watchdog-device/watchdog-device/g' /etc/watchdog.conf > /tmp/watchdog.conf && {
        sudo mv /tmp/watchdog.conf /etc/
    }

    # enable new services
    sudo systemctl enable shutdown-h3
    sudo systemctl daemon-reload
}

main()
{
    # over write files
    copy_files

    # do some hotfix ops
    do_hotfix

    # flash out
    sync
    exit 0
}

# exec
main