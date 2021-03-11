#!/bin/sh

adb root
sleep 1


adb shell mount -o rw,remount /

adb push util/build.prop_patched /system/build.prop

adb shell mount -o ro,remount /



