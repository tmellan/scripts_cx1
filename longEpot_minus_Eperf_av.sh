#!/bin/bash

l="070 658 611 163 775 990 885 110 200 106 312 089" # configs
dir=`pwd` 
L="0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.8 1.0"
#split -l 64 -d -a 3 last1000x64
s=0
#reciprocal of 11 (configs) is 0.09090909
aldirlong="4.685Ang_760K 4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.730Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.759Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.801Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.850Ang_760K  4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K "

rm Epot_minus_Eperf_av_all
for k in $aldirlong; do  
  for j in $L; do
      cd $dir/$k/UP-SAMPLE/lambda$j/ && echo in the directory called $dir/$k/UP-SAMPLE/lambda$j/ &&
      awk '{print $5}' pre_equilibration | sed '1d' | split -l 1000 -d && mv x15 last1000_EpotminusEperf && rm x*
      split -l 1 -d -a 3 last1000_EpotminusEperf

      for i in $l; do
        cp x$i EpotminusEperf_config$i
      done 
      rm x*      
      
      cat EpotminusEperf_config* > All_Epot_minus_Eperf
      echo $dir/$k/UP-SAMPLE/lambda$j/ > place
      awk '{s+=$1}END{print 0.09090909*s}' All_Epot_minus_Eperf > av_Epot_minus_perf
      paste place  av_Epot_minus_perf
      paste place av_Epot_minus_perf >> $dir/Epot_minus_Eperf_av_all
  done
done      
cat $dir/Epot_minus_Eperf_av_al

