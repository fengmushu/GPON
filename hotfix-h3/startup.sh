#!/bin/sh

# set -x

PWD=`pwd`
# KVER=`uname  -r`
KVER='3.4.113+'

copy_files() {
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