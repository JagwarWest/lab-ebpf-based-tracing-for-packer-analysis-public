#!/bin/sh

# create dirs and push the current state of the ebpf scripts
adb push ../ebpf-programs/tests/ /data/androdeb/debian/home/victim/

adb shell chmod -R uog+rwx /data/androdeb/debian/home/victim/tests/