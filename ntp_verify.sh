#!/usr/bin/env bash

ntps=$(systemctl status ntp | grep "Active" | awk '{print $3}' | sed 's/(//' | sed 's/)//')
if [[ $ntps != running ]];
then
	echo "NOTICE: ntp is not running"
	systemctl start ntp
fi
check=$(diff -U 0 /etc/ntp.conf.good /etc/ntp.conf)
if [[ -n "$check" ]];
then
        echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
        echo "$check"
        patch -u /etc/ntp.conf <(diff -U 0 /etc/ntp.conf /etc/ntp.conf.good) > /dev/null
        systemctl restart ntp
fi
