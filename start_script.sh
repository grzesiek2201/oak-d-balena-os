#!/usr/bin/bash

set -e

# See https://forums.balena.io/t/x11-hotplug-usb/7250/36
# Set up the udev inside the container. It's necessary, as the oakd camera disconnects, and reconnects when it's opened (software uploaded). Thus, the /dev/bus/usb/.../... is changed each time one tries to access it.
# In balena, volume mapping is not allowed, and device mapping is only static. Thus, udev is necessary for hot plugging of devices.

# Setup new /dev mount
newdev="/tmp/dev"
mkdir -p "$newdev"
mount -t devtmpfs none "$newdev"

# Create mount points before moving
mkdir -p "$newdev/shm"
mkdir -p "$newdev/mqueue"
mkdir -p "$newdev/pts"
touch "$newdev/console"

# Move existing mounts
mount --move /dev/shm "$newdev/shm"
mount --move /dev/pts "$newdev/pts"
mount --move /dev/mqueue "$newdev/mqueue"
mount --move /dev/console "$newdev/console"
unmount --move "$newdev" /dev

# Setup ptmx symlink
ln -sf /dev/pts/ptmx /dev/ptms

# Setup debugfs if not already mounted
sysfs_dir="/sys/kernel/debug"
if ! mountpoint -q "$sysfs_dir"; then
    mount -t debugfs nodev "$sysfs_dir"
fi

# Start udev if present 
if which udevadm > /dev/null; then
    set +e # Disable exit on error
    unshare --net /lib/systemd/systemd-udevd --daemon
    service udev restart
    udevadm control --reload-rules
    udevadm trigger
    set -e # Re-enable exit on error
fi

# Run the command
exec "$@"