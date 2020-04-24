
mkdir -p /opt/test/
while :;
do
	FILE=`cat /proc/sys/kernel/random/uuid | cut -b -5`
	BSIZE=`printf "%d" 0x$FILE`
	dd if=/dev/zero of=random.$FILE bs=$BSIZE count=1 conv=fsync
	factory get  >> random.$FILE
	mv random.* /opt/test/
	sleep 0.1
	sync
	rm /opt/test/random.*
	sudo dmesg -c
done

