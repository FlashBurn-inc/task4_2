#!/usr/bin/env bash

apt install -y ntp
sleep 10s
conf=/etc/ntp.conf
	$(sed -i '/pool/{/#/!d}' "$conf")
	$(sed -i '/# Specify one or more NTP servers/a\pool ua.pool.ntp.org iburst' "$conf")
cp /etc/ntp.conf /etc/ntp.conf.good

systemctl restart ntp
	$(sed -i '/ntp_verify/d' "/etc/crontab")
	path=$(echo $0 | sed -r 's/ntp_deploy.sh//g')
	if [[ $path != /* && $path != .* ]];
	then
		way=$(echo "$PWD/$path")
	elif [[ $path == .* ]]
	then
		i=$(echo "$path" | sed 's/.\///')
		way=$(echo "$PWD/$i")
	else
		way=${path:-"$PWD"/}
	fi
test=$(dirname $0)
echo "#ntp_verify task4_2" >> /etc/crontab
echo "*/1 * * * * root bash "$way"ntp_verify.sh" >> /etc/crontab
