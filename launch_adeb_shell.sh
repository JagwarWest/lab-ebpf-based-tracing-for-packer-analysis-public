#!/bin/sh
adb root
adb shell mount -o rw,remount /
adb shell ln -s /system/bin/ /bin
adb shell mount -o ro,remount /

adb shell -t /data/androdeb/run
