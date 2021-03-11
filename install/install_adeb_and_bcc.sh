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


echo "THIS WILL TAKE A WHILE!\nTake a nap or get a tea/coffee!"
./adeb/adeb prepare --bcc --build --arch amd64 --buildtar .
./adeb/adeb shell ./bcc-master/build-bcc.sh
./adeb/adeb shell apt update
./adeb/adeb shell apt install xz-utils -y
./adeb/adeb shell apt install python3-pip -y
./adeb/adeb shell pip3 install filemagic

adb shell chmod o-rwx /data/androdeb/*

echo "Bye bye adeb"
rm -rf adeb/
