#!/bin/bash


dir1="4.685Ang_760K 4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K "
dir2="4.730Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K "
dir3="4.759Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K "
dir4="4.801Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K "
dir5="4.850Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K "
voldir=$dir5

l="070 658 611 163 775 990 885 110 200 106 312 089"
dir=`pwd`
L="0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.8 1.0"
C="16"

cd $dir && echo $dir &&
 
for k in $voldir; do
  for j in $L; do    
    for i in $l; do 
      cd $dir/$k && ENDDIR=`pwd | sed 's#.*/##' | sed 's/[^0-9]*//g'` && 
      cd $dir/$k/UP-SAMPLE/lambda$j/proc/config$i/ && 
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '${ENDDIR:5}'_'$j'_'$i'/g' ../../../../../SUBMISSION_STUFF/cx1run.pbs.$C > $dir/$k/UP-SAMPLE/lambda$j/proc/config$i/cx1run.pbs.$C &&
      touch cpu=$C && mv cx1run.pbs.$C prun.pbs && qsub prun.pbs >> $j.note && echo config$i submitted at `date` >> $j.note &&
      cd $dir/$k/UP-SAMPLE/ && echo submitted config$i && echo config$i for lambda$j submitted with $C CPUs at `date` >> $j.note
    done
    echo DONE loop for $j
  done
  echo DONE for loop $k
done
echo TOTALLY DONE - cpu $C job
