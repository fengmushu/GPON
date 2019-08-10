#!/bin/sh

# set -x

PWD=`pwd`

copy_files() {
    sudo cp -a ./fakeroot/* /
}

do_hotfix() {
    # disable 30-armbian-sysinfo, for cause mmc blocked.
    [ -f /etc/update-motd.d/30-armbian-sysinfo ] && {
        sudo mv /etc/update-motd.d/30-armbian-sysinfo /root/etc_update-motd.d_30-armbian-sysinfo
    }

    # fixup timezone
    sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
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