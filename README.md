### GPON OSGI hotfix-plugin

- git submodule update --init
- update the hotfix files, put them into hotfix DIR
- make
- copy the generated "hotfix.run" to target device /tmp and test ...

### TEST
- hotfix.run --keep

### FAQ
- H3开启kernel log to console:
    - /boot/armbianEnv.txt -> loglevel=7, console=both
- 

cat /sys/class/disp/disp/attr/sys

echo switch > /sys/kernel/debug/dispdbg/command
echo disp 0 > /sys/kernel/debug/dispdbg/name
echo 4 38 > /sys/kernel/debug/dispdbg/param
echo 1 > /sys/kernel/debug/dispdbg/start

\# layer disable
echo disable > /sys/kernel/debug/dispdbg/command
echo layer 0 > /sys/kernel/debug/dispdbg/name
echo 1 > /sys/kernel/debug/dispdbg/start

cat /sys/class/disp/disp/attr/sys

\# hotplug-out
echo 0x10 > /sys/devices/virtual/hdmi/hdmi/attr/hpd_mask

dmesg -c


disp_probe -> disp_init -> parser_disp_init_para(scripts.bin) -> 
                        -> disp_boot_para_parse(kernel command)
                        -> bsp_disp_init()

### 优化启动时间:
systemctl disable screencast