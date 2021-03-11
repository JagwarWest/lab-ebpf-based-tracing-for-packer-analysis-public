#!/bin/sh

if [ -f "houdini7_z.sfs" ]
then
    echo "File houdini7_z.sfs already downloaded!"
else
    echo "Downloading houdini64.sfs"
    #curl http://dl.android-x86.org/houdini/7_z/houdini.sfs -o houdini7_z.sfs
    curl "https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc/download?path=%2F&files=houdini7_z.sfs" -o houdini7_z.sfs
fi


if [ -f "houdini7_y.sfs" ]
then
    echo "File houdini7_y.sfs already downloaded!"
else
    echo "Downloading houdini.sfs"
    #curl http://dl.android-x86.org/houdini/7_y/houdini.sfs -o houdini7_y.sfs
    curl "https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc/download?path=%2F&files=houdini7_y.sfs" -o houdini7_y.sfs
fi


adb root
adb shell mount -o rw,remount /


adb shell mkdir -p /data/arm/
adb push util/enable_nativebridge_patched /system/bin/enable_nativebridge
adb push houdini7_z.sfs /system/etc/houdini64.sfs
adb push houdini7_y.sfs /system/etc/houdini.sfs

adb shell ln -s /system/etc/houdini64.sfs /data/arm/houdini7_z.sfs
adb shell ln -s /system/etc/houdini.sfs /data/arm/houdini7_y.sfs

adb shell mount -o ro,remount /

# activating native bridge
echo "Activating nativebridge. Check if app compatibility is also enabled in the \"Settings\" menu"
adb shell /system/bin/enable_nativebridge 64


