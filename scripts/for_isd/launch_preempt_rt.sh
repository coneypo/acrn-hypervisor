#!/bin/bash
# This is an example of launch script for KBL NUC7i7DNH, may need to revise for other platform.

# pci devices for passthru
declare -A passthru_vpid
declare -A passthru_bdf

passthru_vpid=(
["eth"]="8086 156f"
)
passthru_bdf=(
["eth"]="0000:00:1f.6"
)

function launch_hard_rt_vm()
{
#for memsize setting
mem_size=1024M

modprobe pci_stub
# Ethernet pass-through
#echo ${passthru_vpid["eth"]} > /sys/bus/pci/drivers/pci-stub/new_id
#echo ${passthru_bdf["eth"]} > /sys/bus/pci/devices/${passthru_bdf["eth"]}/driver/unbind
#echo ${passthru_bdf["eth"]} > /sys/bus/pci/drivers/pci-stub/bind

CL_image=$(find /root/LaaG_02/ -name *.img)

/usr/bin/acrn-dm -A -m $mem_size -c $1 -s 0:0,hostbridge -U 495ae2e5-2603-4d64-af76-d4bc5a8ec0e5\
  -k /usr/lib/kernel/default-iot-lts2018-preempt-rt \
   --lapic_pt \
   --rtvm \
   --virtio_poll 1000000 \
   -s 3,virtio-console,@stdio:stdio_port \
   -s 4,virtio-blk,$CL_image \
  -B "root=/dev/vda3 rw rootwait maxcpus=$1 nohpet console=hvc0 \
  no_timer_check ignore_loglevel log_buf_len=16M \
  consoleblank=0 tsc=reliable x2apic_phys" hard_rtvm
}

# offline SOS CPUs except BSP before launch UOS
for i in `ls -d /sys/devices/system/cpu/cpu[1-99]`; do
        online=`cat $i/online`
        idx=`echo $i | tr -cd "[1-99]"`
        echo cpu$idx online=$online
        if [ "$online" = "1" ]; then
                echo 0 > $i/online
                echo $idx > /sys/class/vhm/acrn_vhm/offline_cpu
        fi
done

launch_hard_rt_vm 1
