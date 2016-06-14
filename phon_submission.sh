#!/bin/bash

dir=`pwd`
C="16"



for i in {011..146}; do
   echo $i && cd disp-00$i && echo in the dir disp-00$i
   ENDDIR=`pwd | sed 's#.*/##'`
   cp ../../SUBMISSION_STUFF/cx1run.pbs.$C . && echo copied run script to here
   sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$ENDDIR'/g' ../../SUBMISSION_STUFF/cx1run.pbs.$C > cx1run.pbs.$C && echo changed name in run script for $ENDDIR and cx1run.pbs.$C
   touch cpu=$C && mv cx1run.pbs.$C prun.pbs && qsub prun.pbs >> $i.note
   cd $dir
   echo $ENDDIR with cx1run.pbs.$C submitted at `date` >> $i.note
   echo $ENDDIR with cx1run.pbs.$C submitted at `date`
done
echo totally done job with $C cores


cd $dir && cd ../ && ENDDIR=`pwd | sed 's#.*/##' | sed 's/[^0-9]*//g'` && cd $dir && echo in the directory string $ENDDIR


for j in $L; do
echo directory $dir lambda$j submissions for configs{...$l...} for lat-temp string $ENDDIR, which has been shortened to ${ENDDIR:5} for the qsub name, started at `date` > $j.note

  for i in $l; do
    cd $dir && cd ../../SUBMISSION_STUFF/ && cp INCAR KPOINTS cx1run.pbs.$C $dir/lambda$j/proc/config$i/. && echo copied INCAR KPOINTS and CX1 to config$ &&
    cd $dir/lambda$j/proc/config$i && echo in the directory called lambda$j/proc/config$i in $dir &&
    sed -e 's/#PBS -N XXNAMEXX/#PBS -N '${ENDDIR:5}'_'$j'_'$i'/g' ../../../../../SUBMISSION_STUFF/cx1run.pbs.$C > $dir/lambda$j/proc/config$i/cx1run.pbs.$C && echo sed done &&
    touch cpu=$C && mv cx1run.pbs.$C prun.pbs && qsub prun.pbs >> $j.note && echo config$i in lambda$j in  $dir submitted at `date` >> $j.note &&
    cd $dir && echo submitted config$i in $dir with lambda$j &&
    echo config$i submitted at `date` >> $j.note
  done
  echo DONE loop for $j 

done
echo Done Totally jobs with $C cores
