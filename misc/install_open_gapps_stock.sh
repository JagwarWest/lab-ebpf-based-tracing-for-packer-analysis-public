#!/bin/sh


adb root
sleep 1


adb shell mount -o rw,remount /

mkdir tmp/

if [ -f "open_gapps-x86_64-7.1-stock-20201219.zip" ]
then
    echo "File open_gapps-x86_64-7.1-stock-20201219.zip already downloaded!"
else
    echo "Downloading houdini64.sfs"
    curl "https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc/download?path=%2F&files=open_gapps-x86_64-7.1-pico-20201218.zip" -o open_gapps-x86_64-7.1-pico-20201218.zip
fi

#  cp open_gapps-x86_64-7.1-stock-20201219.zip tmp/

unzip -qq open_gapps-x86_64-7.1-stock-20201219.zip "Core/*" -d tmp/


tar --lzip -xf tmp/Core/defaultetc-common.tar.lz -p --directory tmp/

for dir in default-permissions preferred-apps sysconfig;
do
    adb push tmp/defaultetc-common/common/etc/$dir /system/etc/
    adb shell chown -R root /system/etc/$dir/
    adb shell chgrp -R root /system/etc/$dir/
    adb shell chmod og-x /system/etc/$dir/*
done


tar --lzip -xf tmp/Core/defaultframework-common.tar.lz -p --directory tmp/

for dir in com.google.android.maps.xml com.google.android.media.effects.xml;
do
    adb push tmp/defaultframework-common/common/etc/permissions/$dir /system/etc/permissions/
    adb shell chown -R root /system/etc/permissions/$dir
    adb shell chgrp -R root /system/etc/permissions/$dir
    adb shell chmod og-x /system/etc/permissions/$dir
done



for dir in com.google.android.maps.jar com.google.android.media.effects.jar;
do
    adb push tmp/defaultframework-common/common/framework/$dir /system/framework/
    adb shell chown -R root /system/framework/$dir
    adb shell chgrp -R root /system/framework/$dir
    adb shell chmod og-x /system/framework/$dir
done


tar --lzip -xf tmp/Core/googlepixelconfig-common.tar.lz -p --directory tmp/
adb push tmp/googlepixelconfig-common/common/etc/sysconfig/nexus.xml /system/etc/sysconfig/
adb shell chown -R root /system/etc/sysconfig/nexus.xml
adb shell chgrp -R root /system/etc/sysconfig/nexus.xml
adb shell chmod og-x /system/etc/sysconfig/nexus.xml


for dir in gsfcore-all.tar.lz gmscore-x86_64.tar.lz vending-x86_64.tar.lz extservicesgoogle-all.tar.lz configupdater-all.tar.lz extsharedgoogle-all.tar.lz googlebackuptransport-all.tar.lz googlecontactssync-all.tar.lz googlefeedback-all.tar.lz googleonetimeinitializer-all.tar.lz googlepartnersetup-all.tar.lz gsflogin-all.tar.lz setupwizarddefault-all.tar.lz
do
    tar --lzip -xf tmp/Core/$dir -p --directory tmp/
done

adb push tmp/gsfcore-all/nodpi/priv-app/GoogleServicesFramework /system/priv-app/
adb push tmp/gmscore-x86_64/nodpi/priv-app/PrebuiltGmsCore /system/priv-app/
adb push tmp/vending-x86_64/nodpi/priv-app/Phonesky /system/priv-app/

# those services might not be strictly needed
# comment them out if you don't want them
adb push tmp/extservicesgoogle-all/nodpi/priv-app/GoogleExtServices /system/priv-app/
adb push tmp/configupdater-all/nodpi/priv-app/ConfigUpdater /system/priv-app/
adb push tmp/extsharedgoogle-all/nodpi/app/GoogleExtShared /system/priv-app/
adb push tmp/googlebackuptransport-all/nodpi/priv-app/GoogleBackupTransport /system/priv-app/
adb push tmp/googlecontactssync-all/nodpi/app/GoogleContactsSyncAdapter /system/priv-app/
adb push tmp/googlefeedback-all/nodpi/priv-app/GoogleFeedback /system/priv-app/
adb push tmp/googleonetimeinitializer-all/nodpi/priv-app/GoogleOneTimeInitializer /system/priv-app/
adb push tmp/googlepartnersetup-all/nodpi/priv-app/GooglePartnerSetup /system/priv-app/
adb push tmp/gsflogin-all/nodpi/priv-app/GoogleLoginService /system/priv-app/
adb push tmp/setupwizarddefault-all/nodpi/priv-app/SetupWizard /system/priv-app/


for dir in GoogleServicesFramework PrebuiltGmsCore Phonesky GoogleExtServices ConfigUpdater GoogleLoginService GooglePartnerSetup GoogleOneTimeInitializer GoogleFeedback GoogleExtShared GoogleBackupTransport GoogleContactsSyncAdapter SetupWizard
do
    adb shell chown -R root /system/priv-app/$dir/
    adb shell chgrp -R root /system/priv-app/$dir/
    adb shell chmod og-x /system/priv-app/$dir/*
done



# install all gapps
echo "unpacking gapps"

unzip -qq open_gapps-x86_64-7.1-stock-20201219.zip "GApps/*" -d tmp/

for tarfile in $(ls tmp/GApps/)
do 
    tar --lzip -xf tmp/GApps/$tarfile -p --directory tmp/GApps/
done

rm tmp/GApps/*.tar.lz

adb push tmp/GApps/speech-common/common/usr/srec /system/usr/
adb shell chown -R root /system/usr/srec
adb shell chgrp -R root /system/usr/srec

adb push tmp/GApps/cameragoogle-common/common/etc/permissions/com.google.android.camera.experimental2016.xml /system/etc/permissions/
adb push tmp/GApps/cameragoogle-common/common/framework/com.google.android.camera.experimental2016.jar /system/framework/

adb push tmp/GApps/cameragooglelegacy-common/common/etc/permissions/com.google.android.camera2.xml /system/etc/permissions/
adb push tmp/GApps/cameragooglelegacy-common/common/framework/com.google.android.camera2.jar /system/framework/

adb push tmp/GApps/dialerframework-common/common/etc/permissions/com.google.android.dialer.support.xml /system/etc/permissions/
adb push tmp/GApps/dialerframework-common/common/etc/sysconfig/dialer_experience.xml /system/etc/sysconfig/
adb push tmp/GApps/dialerframework-common/common/framework/com.google.android.dialer.support.jar /system/framework/

adb push tmp/GApps/vrservice-common/common/etc/sysconfig/google_vr_build.xml /system/etc/sysconfig/


for dir in $(find tmp/GApps/ | grep .apk$ | grep nodpi | grep priv-app | sed -e "s/\/[a-zA-Z0-9]*.apk//")
do
    adb push $dir /system/priv-app/
done

for dir in $(find tmp/GApps/ | grep .apk$ | grep nodpi | grep "\/app\/" | sed -e "s/\/[a-zA-Z0-9]*.apk//")
do
    adb push $dir /system/app/
done



adb shell chown -R root /system/etc/
adb shell chown -R root /system/framework/
adb shell chown -R root /system/priv-app/
adb shell chown -R root /system/app/

adb shell chgrp -R root /system/etc/
adb shell chgrp -R root /system/framework/
adb shell chgrp -R root /system/app/
adb shell chgrp -R root /system/priv-app/


adb shell mount -o ro,remount /
rm -r tmp/
