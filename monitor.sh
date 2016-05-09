#!/bin/bash


if [ "$THINGSPEAK_API_KEY" = "" ]; then
	echo "THINGSPEAK_API_KEY is not defined"
fi

if [ "$PUSHGATEWAY_PORT" = "" ]; then
	echo "PUSHGATEWAY_PORT is not defined (use --link or --env in format tcp://172.17.0.3:9091)"
fi

/co2mon/build/co2mond/co2mond |
while read line;
do
	echo $line
    f1=$(echo $line | cut -f1 -d" ");
    f2=$(echo $line | cut -f2 -d" ");
    if [ "$f1" = "CntR" ]; then
        fn=1;
    else
        fn=2;
    fi
	if [ "$THINGSPEAK_API_KEY" != "" ]; then
  		echo "$f1 $f2" | curl -m 5 --connect-timeout 2 --data-binary @- http${PUSHGATEWAY_PORT//tcp/}/metrics/job/house_health
	fi
    a=$((a+1))
    if [ $((a%7)) = 0 ]; then
		if [ "$THINGSPEAK_API_KEY" != "" ]; then
			curl -m 5 --connect-timeout 2 "https://api.thingspeak.com/update?api_key=$THINGSPEAK_API_KEY&field$fn=$f2"
			echo
		fi
    fi
done
