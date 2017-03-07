#!/bin/bash

dir=`pwd`
coords="1 480000 492800 496000 496640 720000 732800 739200 768000 864000 867200"
temps="1_300 2_760 3_1900 4_2500 5_3200 6_3805"
temps2="300 760 1900 2500 3200 3805"
kbt="0.00008617332"
volumes="1__4685 2__4730 3__4759 4__4801 5__4850"

for m in $volumes; do 
  cd $m
  vol=$(echo $(basename "$PWD" | tail -c 5)*0.001*2 | bc -l)

  #loop 1 to make the POSCAR and calculations folders
  for j in $temps; do 
    cd $j/MVT/ && 
    rm -r POSCAR_*
    sed -e 's/9.7/'$vol'/g' ../../../SUB_STUFF_MVT_UP/poscar_head > poscar_head
    lam=$(echo lambda0*)
    for i in $coords; do sed -n "$i, $(($i+63)) p" $lam/POSITIONs > tmp_$i ; done
    for i in $coords; do mkdir POSCAR_$i ; cat poscar_head tmp_$i > POSCAR_$i/POSCAR_$i ; cp POSCAR_$i/POSCAR_$i POSCAR_$i/POSCAR ; done
    rm tmp_*
    cd ../../
  done
  echo done loop 1 - make POSCAR and UP-sample calculation folders

  #loop 2 to set up the calculation
  c=0
  for j in $temps; do
    cd $j/ &&

    #loop to assign electronic temperature based on directory name
    for l in $temps2 ; do if [ "$(basename "$PWD" | tail -c 4)" == $l ]||[ "$(basename "$PWD" | tail -c 5)" == $l ] ; then smearing=$(echo $l*$kbt | bc -l) ; echo $smearing ; fi ; done

    cd MVT/
    for i in $coords; do 
      cd POSCAR_$i && 
      cp ../../../../SUB_STUFF_MVT_UP/POTCAR .
      cp ../../../../SUB_STUFF_MVT_UP/KPOINTS .
      sed -e 's/XXSMEARINGXX/'$smearing'/g' ../../../../SUB_STUFF_MVT_UP/INCAR > INCAR
      let c=c+1
      sed -e 's/#PBS -N XXNAMEXX/#PBS -N '$c'_'$j'/g' ../../../../SUB_STUFF_MVT_UP/cx1run.pbs.20 > cx1run.pbs.20 
      cd ../
    done
    cd ../../
  done
  echo done loop2
  
  cd $dir
done
echo done all
