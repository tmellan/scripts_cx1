#!/bin/bash

l="31 97 24 46 83"
dir=`pwd`
L="0.0 0.15 0.5 0.85 1.0"
s=0

aldirlong="4.685Ang_760K 4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.730Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.759Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.801Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.850Ang_760K  4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K "
#aldirold="4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.685Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.730Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.759Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.801Ang_760K 4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K 4.850Ang_760K "

#perf=`grep - $dir/$k/perf* | awk '{print $1}'`
#high=`grep E0= OSZICAR | awk '{print $3}'`

rm out.energz out.E_dft_high_minus_dft_perf high_minus_perf_av &
for k in $aldirlong; do  
  for j in $L; do
  rm $dir/$k/UP-SAMPLE/lambda$j/E_DFT_high_all &
    for i in $l; do
      cd $dir/$k/UP-SAMPLE/lambda$j/proc/config$i && echo in the directory called $dir/$k/UP-SAMPLE/lambda$j/proc/config$i &&
      echo `grep E0= OSZICAR | awk '{print $3}'`
      let s=s+1 && echo $s 
      perf=`grep - $dir/$k/perf* | awk '{print $1}'`
      high=`grep E0= OSZICAR | awk '{print $3}'` 
      echo $s $dir/$k/UP-SAMPLE/lambda$j/proc/config$i 'E0= ' $high >> $dir/tmp1
      echo $high >> $dir/$k/UP-SAMPLE/lambda$j/E_DFT_high_all
      echo $s $dir/$k/UP-SAMPLE/lambda$j/proc/config$i 'E_DFT_high ' $high ' E_DFT_perf ' $perf 'E_DFT_high_minus_perf' >> $dir/tmp2
    done
    
    awk '{s+=$1}END{print s}' $dir/$k/UP-SAMPLE/lambda$j/E_DFT_high_all > $dir/$k/UP-SAMPLE/lambda$j/sum_E_DFT_high_all
    paste $dir/$k/UP-SAMPLE/lambda$j/sum_E_DFT_high_all $dir/$k/perf* > $dir/$k/UP-SAMPLE/lambda$j/high_and_perf

###########MAKE SURE THE AVERAGE IS ADJUSTED FOR THE NUMBER OF LAMBDAS
    awk '{ $3 = 0.2*$1-$2 } 1' $dir/$k/UP-SAMPLE/lambda$j/high_and_perf > $dir/$k/UP-SAMPLE/lambda$j/high_minus_perf_av
    echo $s $dir/$k/UP-SAMPLE/lambda$j/ > $dir/$k/UP-SAMPLE/lambda$j/tmp4 &&  paste $dir/$k/UP-SAMPLE/lambda$j/tmp4 $dir/$k/UP-SAMPLE/lambda$j/high_minus_perf_av > $dir/$k/UP-SAMPLE/lambda$j/high_minus_perf_av_name
    cat $dir/$k/UP-SAMPLE/lambda$j/high_minus_perf_av_name >> $dir/tmp4
  done 
  echo done for all lambda values

done
echo done for all V-T points


cd $dir
column -t tmp1 > out.energz
column -t tmp2 > tmp3
column -t tmp4 > high_minus_perf_config_av
awk '{ $8 = $4 - $6 } 1' tmp3 > out.E_dft_high_minus_dft_perf
rm tmp1 tmp2 tmp3 tmp4
cat out.energz out.E_dft_high_minus_dft_perf high_minus_perf_config_av


