#!/bin/bash

n="X"
dir=`pwd`
band="band1 band7 band21 band31 band41 band52 band55 band63 band76 band80 band85 band93 band98 band105 band113 band120 band139 band147 band150 band162 band167 band172 band183 band192"
bandtest="band1"

for j in $band; do
  cd $j 
  bandindex=`basename "$PWD" | sed -e s/[^0-9]//g`
  for i in {001..027}; do 
    rm -r $i
    mkdir $i
    cd $i
    cp ../MPOSCAR-$i POSCAR
    cp ../../../SUB_stuff/* .
    sed -e 's/#PBS -N 4_001/#PBS -N '$n'.'$bandindex'.'$i'/g' ../../../SUB_stuff/cx1run.pbs.16 > cx1run.pbs.16
    cd ../
    echo done $i
  done 
  cd $dir
  echo done all
done
echo doneALL!
