#!/bin/sh
adb root
sleep 1

#adb shell mount -o rw,remount /
#adb shell ln -s /system/bin/ /bin
#adb shell mount -o ro,remount /

adb shell mkdir -p /data/androdeb/debian/storage/emulated/0/
adb shell mount --bind /storage/emulated/0/ /data/androdeb/debian/storage/emulated/0/

adb shell mkdir -p /data/androdeb/debian/storage/self/primary/
adb shell mount --bind /storage/self/primary/ /data/androdeb/debian/storage/self/primary/

adb shell mkdir -p /data/androdeb/debian/sdcard/
adb shell mount --bind /sdcard/ /data/androdeb/debian/sdcard/

#adb shell mkdir -p /data/androdeb/debian/data/media/0/
#adb shell mount --bind /data/media/0/ /data/androdeb/debian/data/media/0/

#adb shell mkdir -p /data/androdeb/debian/data/app/
#adb shell mount /data/app/ /data/androdeb/debian/data/app/

#adb shell mkdir -p /data/androdeb/debian/data/security/
#adb shell mount /data/security/ /data/androdeb/debian/data/security/

#adb shell mkdir -p /data/androdeb/debian/data/dalvik-cache/
#adb shell mount /data/dalvik-cache/ /data/androdeb/debian/data/dalvik-cache/


echo "Finished mounts"
