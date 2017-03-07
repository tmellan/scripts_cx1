#!/bin/bash

config="1 7501 7701 7751 7761 11251 11451 11551 12001 13501 13551"
#config="1 7500 7700 7750 7760 11250 11450 11550 12000 13500 13550"
config2="7501 7701 7751 7761 11251 11451 11551 12001 13501 13551"
#config2="7500 7700 7750 7760 11250 11450 11550 12000 13500 13550"
dir=`pwd`
coords="1 480001 492801 496001 496641 720001 732801 739201 768001 864001 867201"
temps="1_300 2_760 3_1900 4_2500 5_3200 6_3805"
temps2="300 760 1900 2500 3200 3805"
kbt="0.00008617332"
volumes="1__4685 2__4730 3__4759 4__4801 5__4850"


#Collect the qha to MEAM TI energies
rm $dir/TI_EpotminusEperf_all
for k in $volumes; do 
  for j in $temps; do 
    cd $k/$j/MVT/ && lam=$(echo lambda0*) &&
    for i in $config; do sed -n "$((i+1)), $((i+1)) p " $lam/dUdL ; done > TI_EpotminusEperf  && echo $k/$j/MVT && cat TI_EpotminusEperf
    for i in $config; do sed -n "$((i+1)), $((i+1)) p " $lam/dUdL ; done >> $dir/TI_EpotminusEperf_all
    cd $dir
  done
  echo done loop $volumes
done
echo ************DONE PART ONE - TI_EpotminusEperf_all ****************

#Collect the qha-MEAM TI excluding the perfect energies 
rm $dir/TI_EpotminusEperf_all2
for k in $volumes; do
  for j in $temps; do
    cd $k/$j/MVT/ && lam=$(echo lambda0*) &&
    for i in $config2; do sed -n "$((i+1)), $((i+1)) p " $lam/dUdL ; done > TI_EpotminusEperf2  && echo $k/$j/MVT && cat TI_EpotminusEperf2
    for i in $config2; do sed -n "$((i+1)), $((i+1)) p " $lam/dUdL ; done >> $dir/TI_EpotminusEperf_all2
    cd $dir
  done
  echo done loop $volumes
done
echo ************DONE PART TWO - TI_EpotminusEperf_all2 ****************


#
#Collect the UP-sample energies
rm $dir/TI_UP_Fall $dir/TI_UP_E0all

for k in $volumes; do
  for j in $temps; do
    cd $k/$j/MVT/ && rm TI_UP_F TI_UP_E0
    for i in $coords; do grep 'E0=' POSCAR_$i/OSZICAR | awk '{print $3}' ; done > TI_UP_F ; echo $k/$j/MVT ; cat TI_UP_F 
    for i in $coords; do grep 'E0=' POSCAR_$i/OSZICAR | awk '{print $5}' ; done > TI_UP_E0  
    for i in $coords; do grep 'E0=' POSCAR_$i/OSZICAR | awk '{print $3}' ; done >> $dir/TI_UP_Fall 
    for i in $coords; do grep 'E0=' POSCAR_$i/OSZICAR | awk '{print $5}' ; done >> $dir/TI_UP_E0all 
    cd $dir
  done
  echo done loop $k
done

for k in $volumes; do paste $k/*/MVT/TI_UP_F > TI_UP_F_$k ; done
for k in $volumes; do paste $k/*/MVT/TI_UP_E0 > TI_UP_E0_$k ; done
for k in $volumes; do cd $k ; cat */MVT/TI_EpotminusEperf2 > ../TI_EpotminusEperf_$k ; cd ../ ; done
