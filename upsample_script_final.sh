#!/bin/bash

mkdir temp_files

cut -f 2 Epot_minus_Eperf_av_all > tmp_EpotmeVat
awk '{$6=$5*1000/64}'1 high_minus_perf_config_av | cut -d " " -f1,2,6 > tmp_EDFTmeVat

paste tmp_EDFTmeVat tmp_EpotmeVat > tmp_DFT_POT
awk '{$1=0.2*$1 ; $5=$3-$4}'1 tmp_DFT_POT > tmp_DFT_POT_diff

echo index where-vol-temp-lambda E_DFT_meVat E_POT_meVat UPSAMPLE_DFT-POT_meVat  > tmp_up_sample_header

cat tmp_up_sample_header tmp_DFT_POT_diff | column -t > out.UP-sample

sed '1d' out.UP-sample > tmp_outupsample && split -l 25 -d tmp_outupsample out.UPvol

for i in {1..125}; do
  echo $i >> index
done

split -l 25 -d index index

split -l 5 -d tmp_outupsample tmp_out.UPtemp

rm index
cat tmp_out.UPtemp00 tmp_out.UPtemp05 tmp_out.UPtemp10 tmp_out.UPtemp15 tmp_out.UPtemp20 > tmp_out.UPtemp760 && paste index00 tmp_out.UPtemp760 > out.UPtemp760
cat tmp_out.UPtemp01 tmp_out.UPtemp06 tmp_out.UPtemp11 tmp_out.UPtemp16 tmp_out.UPtemp21 > tmp_out.UPtemp1900 && paste index01 tmp_out.UPtemp1900 > out.UPtemp1900
cat tmp_out.UPtemp02 tmp_out.UPtemp07 tmp_out.UPtemp12 tmp_out.UPtemp17 tmp_out.UPtemp22 > tmp_out.UPtemp2500 && paste index02 tmp_out.UPtemp2500 > out.UPtemp2500
cat tmp_out.UPtemp03 tmp_out.UPtemp08 tmp_out.UPtemp13 tmp_out.UPtemp18 tmp_out.UPtemp23 > tmp_out.UPtemp3200 && paste index03 tmp_out.UPtemp3200 > out.UPtemp3200
cat tmp_out.UPtemp04 tmp_out.UPtemp09 tmp_out.UPtemp14 tmp_out.UPtemp19 tmp_out.UPtemp24 > tmp_out.UPtemp3805 && paste index04 tmp_out.UPtemp3805 > out.UPtemp3805

mv tmp_* temp_files
echo done

