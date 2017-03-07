#!/bin/bash

dir=`pwd`
coords="1 480001 492801 496001 496641 720001 732801 739201 768001 864001 867201"
temps="1_300 2_760 3_1900 4_2500 5_3200 6_3805"
temps2="300 760 1900 2500 3200 3805"
kbt="0.00008617332"
volumes="1__4685 2__4730 3__4759 4__4801 5__4850"

for i in $volumes; do
  for j in $temps; do 
    for k in $coords; do
      cd $i/$j/MVT/POSCAR_$k/ && 
      echo `pwd`
      qsub cx1run.pbs.20 > 1.out && cat 1.out &&
      cd $dir
    done
  done
done
echo done 
