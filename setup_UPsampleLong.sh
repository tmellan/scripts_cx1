#!/bin/bash
#NOTE - - - SET the number of configs manually ie 5000 or 3000
#4850 and 4685 are 3000, others 5000 for some reason
maxval=50000
#constant
kbt="0.00008617332"
dir=`pwd`
volumes="4850"

temps="1_300 2_760 3_1900 4_2500 5_3200 6_3805"
temps2="300 760 1900 2500 3200 3805"

# IMPORANT - For this long accuracte run, lets take 50 up-samples, with each one separated by 500 steps starting from the end

for m in $volumes; do 
  cd $m
  vol=$(echo $(basename `pwd` | head -c 4)*0.001 | bc -l)
  volume=$(echo "scale=16 ; $vol*2" | bc -l)
  #loop 1 to make the POSCAR and calculations folders
  for j in $temps2; do 
    cd $j/ && 
    sed -e 's/xxVOLxx/'$volume'/g' ../../SUB_STUFF_MVT_UP/poscar_head > poscar_head
    configs=$(for i in {0..50}; do echo $maxval - $i*500 -1 | bc -l ; done)
    coords=$(for j in $configs; do echo $j*64 + 1 | bc -l ; done)
    for i in $coords; do sed -n "$i, $(($i+63)) p" POSITIONs > tmp_$i ; done
    for i in $coords; do rm -r POSCAR_$i ; mkdir POSCAR_$i ; cat poscar_head tmp_$i > POSCAR_$i/POSCAR_$i ; cp POSCAR_$i/POSCAR_$i POSCAR_$i/POSCAR ; done
    rm tmp_*
    cd ../
  done
  echo done loop 1 - make POSCAR and UP-sample calculation folders
  #loop 2 to set up the calculation
  c=0
  for j in $temps2; do
    cd $j/
    #loop to assign electronic temperature based on directory name
#    for l in $temps2 ; do if [ "$(basename "$PWD" | tail -c 4)" == $l ]||[ "$(basename "$PWD" | tail -c 5)" == $l ] ; then smearing=$(echo $l*$kbt | bc -l) ; echo $smearing ; fi ; done
    for i in $coords; do 
      cd POSCAR_$i && 
      cp ../../../SUB_STUFF_MVT_UP/POTCAR .
      cp ../../../SUB_STUFF_MVT_UP/KPOINTS .
      cp ../../../SUB_STUFF_MVT_UP/INCAR .
      let c=c+1
#put in two submission scripts just in case
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../SUB_STUFF_MVT_UP/cx1run.pbs.16 > cx1run.pbs.16
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../SUB_STUFF_MVT_UP/cx1run.pbs.20 > cx1run.pbs.20
      cd ../
    done
    cd ../
  done
  echo done loop2  
  cd $dir
done
echo done all
