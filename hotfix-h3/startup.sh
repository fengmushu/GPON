#!/bin/sh

# set -x

PWD=`pwd`

copy_files() {
    sudo cp -a ./fakeroot/* /
}

do_hotfix() {
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