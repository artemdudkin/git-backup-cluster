#!/bin/bash
#set -x #echo on

cd ~/reclone/

./reclone.sh testing      194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh reclone      194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh log          194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh dnevnik      194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh codemirror   194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh alinadudkina 194.67.209.146 >> ./reclone.log 2>> ./reclone.log

./reclone.sh pipvip-front 194.67.209.146 >> ./reclone.log 2>> ./reclone.log
./reclone.sh IB           194.67.209.146 >> ./reclone.log 2>> ./reclone.log

