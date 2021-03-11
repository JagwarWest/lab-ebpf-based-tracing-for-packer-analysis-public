#!/bin/sh
if [ $# -eq 1 ]
then
    adb root

    filename=`openssl x509 -in $1 -noout -subject_hash_old`.0
    echo "CERT: $filename"
    cp $1 $filename

    adb shell mount -o rw,remount /
    adb push $filename /system/etc/security/cacerts/$filename
    adb shell chmod 644 /system/etc/security/cacerts/$filename
    adb shell mount -o ro,remount /

    rm $filename

    echo "Don't forget to reboot to let it take effect"
else
    echo "Please specify a path to your root certificate!"
fi
