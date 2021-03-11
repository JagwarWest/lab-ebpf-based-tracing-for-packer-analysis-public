#!/bin/sh
adb root
echo "Waiting 2 seconds for 'adb root' to finish "
sleep 2

# so that adeb will work
adb shell mount -o rw,remount /
adb shell ln -s /system/bin/ /bin
adb shell mount -o ro,remount /


git clone https://github.com/joelagnel/adeb.git

# first bcc build seems to fail with the current adeb build
# I replaced the buildstrap file to make to compilation manually later on
cp util/buildstrap adeb/

./adeb/adeb prepare --archive $1

adb shell chmod o-rwx /data/androdeb/*

rm -rf adeb/