#!/bin/bash

####### to run in /work/tmellan/UP-sample-test/kp444700_long16000/long_EAM_UPTILD
# note splitting the pre_POSITIONS file in sections 64000 long ie 1000 configs, rather than into 100 as with the shorter run.
l="0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0"
dir=`pwd`
aldirlong="4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.685Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.730Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.759Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.801Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K 4.850Ang_760K "

cd $dir && echo in the directory $dir
for j in $aldirlong; do
  cd $dir/$j && echo in the directory called $j

  for i in $l; do
    cd lambda$i && echo in the directory lambda$i
    rm -r proc 
    mkdir proc
    cp pre_POSITIONs proc/pre_POSITIONs && cd proc/ && split -l 64000 -d pre_POSITIONs  && mv x15 last1000x64 && rm x*  
    cd $dir/$j
  done
    
done
