#!/bin/sh
if [ $# -eq 1 ]
then
    echo "You are redirecting to: ->$1<-"
    adb root
    adb shell iptables -t nat -F OUTPUT
    adb shell iptables -t nat -A OUTPUT -p tcp --dport 1:65535 -j DNAT --to $1
else
    echo "Please specify a proxy address (e.g. 10.0.0.1:8181)"
fi