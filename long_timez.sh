#!/bin/bash

l="070 658 611 163 775 990 885 110 200 106 312 089"
dir=`pwd`
L="0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.8 1.0"
s=0

dir1="4.685Ang_760K 4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K "
dir2="4.730Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K "
dir3="4.759Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K "
dir4="4.801Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K "
dir5="4.850Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K "
aldirlong="4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.685Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.730Ang_760K 4.759Ang_1900K     4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.759Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.801Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K 4.850Ang_760K "
diruse=$dir5

echo doing for $diruse

rm  out.timez &

for k in $diruse; do 
  for j in $L; do
    for i in $l; do
      cd $dir/$k/UP-SAMPLE/lambda$j/proc/config$i && echo in the directory called $dir/$k/UP-SAMPLE/lambda$j/proc/config$i &&
      echo $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1))
      let s=s+1 && echo $s
      echo $s' ' $dir/$k/UP-SAMPLE/lambda$j/proc/config$i ' ' $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1)) >> $dir/out.timez
    done
    echo DONE loop for $j 
  done 
  echo done for all lambda values
done
echo done for all V-T points


cd $dir
cat out.timez
