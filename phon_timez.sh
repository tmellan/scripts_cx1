#!/bin/bash


dir=`pwd`
s=0
for i in {001..146}; do
   let s=s+1
   echo $s $i && cd disp-00$i && echo in the dir disp-00$i
   ENDDIR=`pwd | sed 's#.*/##'`
   echo $s dir_is: $ENDDIR and_time:  $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1)) >> $dir/out.timez
   cd $dir
done
