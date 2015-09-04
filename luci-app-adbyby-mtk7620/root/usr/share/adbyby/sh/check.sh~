#!/bin/sh 
#感谢小兔兔
wget -P /tmp http://www.baidu.com/img/bdlogo.png
if [ -f /tmp/bdlogo.png ]; then
	rm -f /tmp/bdlogo.png
	PIDS=$(ps | grep "adbyby" | grep -v "grep" | wc -l)
		if [ "$PIDS" = 0 ]; then
			/etc/init.d/adbyby restart
		else
		port=$(iptables -t nat -L | grep 8118 | wc -l)
			if [ "$port" = 0 ]; then
				/etc/init.d/adbyby restart
			fi
			if [ "$port" = 2 ]; then
				iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118
			fi
			if [ "$PIDS" -ge 6 ]; then
				ps |grep "/usr/share/adbyby/adbyby" | grep -v 'grep' | awk '{print $1}' |xargs kill -9
				/etc/init.d/adbyby restart
			fi

		fi
else
	rm -f /tmp/bdlogo.png
	/etc/init.d/adbyby stop
fi
