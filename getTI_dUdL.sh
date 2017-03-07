#!/bin/bash
dir=`pwd`
aldirlong="4.685Ang_760K 4.685Ang_1900K 4.685Ang_2500K 4.685Ang_3200K 4.685Ang_3805K 4.730Ang_760K 4.730Ang_1900K 4.730Ang_2500K 4.730Ang_3200K 4.730Ang_3805K 4.759Ang_760K 4.759Ang_1900K 4.759Ang_2500K 4.759Ang_3200K 4.759Ang_3805K 4.801Ang_760K 4.801Ang_1900K 4.801Ang_2500K 4.801Ang_3200K 4.801Ang_3805K 4.850Ang_760K  4.850Ang_1900K 4.850Ang_2500K 4.850Ang_3200K 4.850Ang_3805K "

####### Remove any tmp files
rm $dir/UP_plus_TI_final/tmp*

####### In all 25 V-T points run getdUdL.sh script
####### Open the results and print them to a temp file in ../UP_plus_TI_final/..
for i in $aldirlong; do  
  cd $dir/$i/UP-SAMPLE/ && $dir/getdUdL.sh && cd $dir &&
  cat $dir/$i/UP-SAMPLE/avg_dUdL | awk '{print $2}' >> $dir/UP_plus_TI_final/tmp.dUdL_all
done      

###### Copy the UP-sample results over as a tmp file, removing the ffirst line
sed '1d' $dir/final_upsample/out.UP-sample > $dir/UP_plus_TI_final/tmp.UP-sample 

paste $dir/UP_plus_TI_final/tmp.UP-sample $dir/UP_plus_TI_final/tmp.dUdL_all | awk '{$7=$5+$6}'1 | column -t > $dir/UP_plus_TI_final/tmp.TIplusdUdL
cat $dir/UP_plus_TI_final/head $dir/UP_plus_TI_final/tmp.TIplusdUdL | column -t > $dir/UP_plus_TI_final/out.TIplusdUdL 
###### Paste the dUdL results onto the UP-sample results, and add an extra column with the TI+dUdL and save as "out.TIplusdUdL"

###### echo the TIplusdUdL data
cat $dir/UP_plus_TI_final/out.TIplusdUdL

###### move to the UP_plus_TI_final folder
cd $dir/UP_plus_TI_final/

###### split the tmp TIplusdUdL data in five line (lambda) sections
awk '{print $7}' tmp.TIplusdUdL | split -l 5 -d 

###### copied fortran FIVE LAMBDA integration executable in
cp $dir/integrate_5_dUdL_TI_exact $dir/UP_plus_TI_final/

###### loop over 25 x$j folders containing dUdL+Ti to integrate over lambda
for j in {00..24}; do
  mv x$j dUdLTI
  ./integrate_5_dUdL_TI_exact
  mv exact_lam5_dUdL_TI_integrated_value tmp.int_dUdL_TI$j
done

cat head_int tmp.int_dUdL_TI* > out.integrated_dUdLplusTI

###### make a temp folder and move all tmp stuff there
mkdir $dir/UP_plus_TI_final/temp
mv $dir/UP_plus_TI_final/tmp* $dir/UP_plus_TI_final/temp/.

echo done!
cat out.integrated_dUdLplusTI
