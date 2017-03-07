#!/bin/bash

for i in {1..7}; do 
  cd UP_sample/$i/ 
  cp ../../POTCAR .
  qsub cx1run.pbs.16
  cd ../../
  echo done $i
done
echo done all

qstat -u tmellan
