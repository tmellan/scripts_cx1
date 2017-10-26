#!/bin/bash
#1) Run setup 
#2) submit
#3) get_DFT_tu-tild-Shifted-MEAM.sh
#4) get_Uref_for_Up_sample.sh

maxval=10000
#constant
kbt="0.00008617332"
dir=`pwd`
#volumes="4685_lin_1.02699 4730_lin_1.08671 4759_lin_1.13373 4801_lin_1.1102 4850_lin_1.04339"
volumes="4685_nonLin_1.02029 4730_nonLin_1.07171 4759_nonLin_1.11615 4801_nonLin_1.0959 4850_nonLin_1.0434"

#Increase the number of up-samples with temperature - 4 for 300, 8 for 760, 16 for 1900, 32 for 2500, 64 for 3200, 128 for 3805
UpNo=(4 8 16 32 64 128)
temps="1_300 2_760 3_1900 4_2500 5_3200 6_3805"
temps2="300 760 1900 2500 3200 3805"

# IMPORANT - For this long accuracte run, lets take 50 up-samples, with each one separated by 500 steps starting from the end
#UPDATE - the variance depends exp on temp, so lets double the sample length with each increase in temperature

for m in $volumes; do 
  cd $m
  vol=$(echo $(basename `pwd` | head -c 4)*0.001 | bc -l)
  volume=$(echo "scale=16 ; $vol*2" | bc -l)
  #loop 1 to make the POSCAR and calculations folders
  b=-1
  for j in $temps2; do 
    let b=b+1
    cd $j/4thOrderMVT/ && 
    sed -e 's/xxVOLxx/'$volume'/g' ../../../SUB_STUFF_MVT_UP/poscar_head > poscar_head
    configs=$(for i in `seq 0 ${UpNo[$b]}`; do echo $maxval - $i*50 -1 | bc -l ; done)
    coords=$(for j in $configs; do echo $j*64 + 1 | bc -l ; done)
    for i in $coords; do sed -n "$i, $(($i+63)) p" POSITIONs > tmp_$i ; done
    for i in $coords; do rm -r POSCAR_$i ; mkdir POSCAR_$i ; cat poscar_head tmp_$i > POSCAR_$i/POSCAR_$i ; cp POSCAR_$i/POSCAR_$i POSCAR_$i/POSCAR ; done
    rm tmp_*
    cd ../../
  done
  echo done loop 1 - make POSCAR and UP-sample calculation folders
  #loop 2 to set up the calculation
  c=0
  b=-1
  for j in $temps2; do
    cd $j/4thOrderMVT/
    pwd
    #loop to assign electronic temperature based on directory name
#    for l in $temps2 ; do if [ "$(basename "$PWD" | tail -c 4)" == $l ]||[ "$(basename "$PWD" | tail -c 5)" == $l ] ; then smearing=$(echo $l*$kbt | bc -l) ; echo $smearing ; fi ; done
    for i in $coords; do 
      cd POSCAR_$i && 
      pwd
      cp ../../../../SUB_STUFF_MVT_UP/POTCAR .
      cp ../../../../SUB_STUFF_MVT_UP/KPOINTS .
      cp ../../../../SUB_STUFF_MVT_UP/INCAR .
      let c=c+1
#put in two submission scripts just in case
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../../SUB_STUFF_MVT_UP/cx1run.pbs.16 > cx1run.pbs.16
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../../SUB_STUFF_MVT_UP/cx1run.pbs.20 > cx1run.pbs.20
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../../SUB_STUFF_MVT_UP/thos.pbs > thos.pbs
      cd ../
    done
    cd ../../
  done
  echo done loop2  
  cd $dir
done
echo done all
