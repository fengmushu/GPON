#!/bin/sh

# set -x

PWD=`pwd`
# KVER=`uname  -r`
KVER='3.4.113+'

DEBS_DIR="/var/cache/apt/archives/"
DEBS_LIST="watchdog_5.14-3ubuntu0.16.04.1_armhf.deb"
UBOOT_BIN="u-boot-sunxi-with-spl.bin"
EMMC_DEVICE="/dev/mmcblk0"
CURR_DISP_MODE=`bin2fex /boot/script.bin 2>/dev/null | grep screen0_output_mode | awk '{print $3}'`

copy_files() {
    # stop evtest-h3
    sudo killall evtest-h3

    # do copy
    cd $PWD
    sudo cp -a ./fakeroot/* /

    # disk hacker
    [ -f "${UBOOT_BIN}" ] && {
        UBOOT_SUM=`dd if=${EMMC_DEVICE} bs=1024 skip=8 count=512 2>/dev/null | md5sum | cut -b-32`
        NEW_SUM=`dd if=${UBOOT_BIN} bs=1024 count=512 2>/dev/null | md5sum | cut -b-32`
        echo "current uboot: ${UBOOT_SUM} vs new: ${NEW_SUM}"
        [ x"${UBOOT_SUM}" = x"${NEW_SUM}" ] || {
            dd if=${UBOOT_BIN} of=${EMMC_DEVICE} bs=1024 seek=8 conv=notrunc,fsync
            echo "new bootloader updated $?"
        }
    }
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

    # restore h3disp
    echo "restore current disp mode: ${CURR_DISP_MODE}"
    h3disp -m ${CURR_DISP_MODE}
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