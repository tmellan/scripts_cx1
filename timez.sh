#!/bin/bash

l="31 97 24 46 83"
dir=`pwd`
L="0.0 0.15 0.5 0.85 1.0"
s=0
aldirlong="4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.685Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.730Ang_760K 4.759Ang_1900K     4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.759Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.801Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_    3200K 4.850Ang_3805K 4.850Ang_760K "
#cd $dir && cd ../ && ENDDIR=`pwd | sed 's#.*/##' | sed 's/[^0-9]*//g'` && cd $dir && echo in the directory string $ENDDIR

rm out.mins out.counter out.dir out.timez &

for k in $aldirlong; do 
  for j in $L; do
#echo directory lambda$j submissions for configs{...$l...} for lat-temp string $ENDDIR, which has been shortened to ${ENDDIR:5} for the qsub name, started at `date` > $j.note
    for i in $l; do
      cd $dir/$k/UP-SAMPLE/lambda$j/proc/config$i && echo in the directory called $k/UP-SAMPLE/lambda$j/proc/config$i &&
      echo $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1)) &&
      let s=s+1 && echo $s
      echo $s' ' pwd_is_$dir $k/UP-SAMPLE/ lambda$j config$i ' ' $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1)) >> $dir/out.timez
#    echo pwd_is_$dir >> $dir/out.dir
#    echo ' ' $((`cat OUTCAR | grep "Total CPU time used (sec):" | sed 's/[^0-9]*//g'`/60000 + 1)) >> $dir/out.mins
    done
    echo DONE loop for $j 
  done 
  echo done for all lambda values
done
echo done for all V-T points


cd $dir
cat out.timez
#cat out.counter && cat out.dir && cat  out.mins
