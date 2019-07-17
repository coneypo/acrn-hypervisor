# !bin/bash

# Install preempt-rt modules in clear linux image

CL_image=$(find /root/LaaG_02/ -name *.img)

# mount virtual disk
losetup -f -P --show $CL_image
mount /dev/loop0p3 /mnt

# install modules
rt_modules=$(find /usr/lib/modules -name *preempt-rt)
cp -r $rt_modules /mnt/lib/modules/
# umount disk
umount /mnt
losetup -D
