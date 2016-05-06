#!/bin/bash

if [[ -z "$1" ]]; then
  exit 1
fi

zimbra_log_file="/var/log/zimbra-stats.log"
zimbra_discovery="$(tail -n 1000 /var/log/zimbra-stats.log | grep STATUS | cut -d ':' -f 10 | sort | uniq)"

case "$1" in
    discovery)
        echo -n '{"data":['
        for service in $zimbra_discovery; do
            echo -n "{\"{#ZIMBRASERVICE}\": \"$service\"},";
        done |sed -e 's:\},$:\}:'
        echo -n ']}'
    exit 0;
    ;;
    *)
	if [ $1 = "" ]; then
	  echo "ERROR: argument required"
	  exit 1
	fi

        state="$(/usr/bin/tail -n 1000 $zimbra_log_file | grep STATUS | grep $1 | tail -1 | cut -d ' ' -f 13)"

	if [ "$state" != "Running" ]; then
	  echo 0
	else
	  echo 1
	fi
    ;;
esac

exit 0;
