#!/bin/sh

#rw
remount_root_rw() {
    mount ubi:rootfs_ubifs / -orw,remount,sync
}

#copy files

#update conf

#restart jamvm
{
    #rm cache
}


../jamvm/bin/jamvm -Dfile.encoding=UTF-8 -Xms32M -Xmx64M -Xss256K -jar bin/felix.jar