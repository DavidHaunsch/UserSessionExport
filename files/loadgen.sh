#!/bin/bash

RAND=$(( ( RANDOM % 10 )  + 1 ))
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`

echo "$DATE_WITH_TIME: scheduling $RAND visits" >> /tmp/loadgen.status

while [ $RAND -ne 0 ]; do
  if  [ $(($RAND%2)) -eq 0 ]
  then
    /usr/local/bin/casperjs /home/ubuntu/iphone8.js
  else
    /usr/local/bin/casperjs /home/ubuntu/macos.js
  fi
  let RAND=RAND-1
done