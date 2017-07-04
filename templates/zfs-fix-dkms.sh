#!/bin/sh
#
# --- zfs-dkms-fix.sh ---
#
# This script automates the process of fixing ZFS after a kernel
# update. See: https://github.com/zfsonlinux/zfs/issues/3801
###################################################################

##
## via https://gist.github.com/dominic-p/2febe31d47576de58f79ee78e4aab023
##


# Get the current ZFS and SPL module versions
modversion=$(dkms status | cut -d , -f 2 | tail -n 1 | xargs)

dkms status

read -p "Detected ZFS/SPL module version as \"$modversion\". If this looks correct given the output above, enter y to continue. Otherwise, enter n to abort and resolve the situation manually. [y/N] " proceed

[ "$proceed" = "y" ] || exit

# Clean out old kernel modules
echo "Removing existing DKMS modules..."
dkms remove -m zfs -v $modversion --all
dkms remove -m spl -v $modversion --all

ls /lib/modules/*/extra/*
ls /lib/modules/*/weak-updates/*

echo "ZFS related modules are: "
echo "plat.ko zavl.ko zfs.ko zpios.ko spl.ko zcommon.ko znvpair.ko zunicode.ko"

read -p "The modules listed above are about to be deleted. If they are all ZFS related, enter y to continue. Otherwsie, enter n to abort and continue manually. [y/N] " proceedagain

[ "$proceedagain" = "y" ] || exit

rm -rf /lib/modules/*/extra/*
rm -rf /lib/modules/*/weak-updates/*

# Reinsall ZFS and SPL
echo "Reinstalling ZFS and SPL..."
yum reinstall spl
yum reinstall zfs

# Readd and reinstall the DKMS moudles
echo "Rebuilding DKMS modules..."
dkms add -m spl -v $modversion
dkms add -m zfs -v $modversion
dkms install -m spl -v $modversion
dkms install -m zfs -v $modversion

# Load the modules
echo "Loading modules..."
/sbin/modprobe spl
/sbin/modprobe zfs

#Output zpool status
echo "Repair script complete. Here is the output of: zpool status"
zpool status
