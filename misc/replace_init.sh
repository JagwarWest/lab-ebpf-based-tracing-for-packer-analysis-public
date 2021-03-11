#!/bin/sh


adb root
sleep 1

adb shell mount -o rw,remount /
adb push util/init.sh /system/etc/init.sh
adb shell mount -o ro,remount /

echo "DONE! Don't forget to reboot!"



