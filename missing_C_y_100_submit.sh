#!/bin/bash


dir=`pwd`
#vols="4.65837 4.685 4.730 4.759 4.801 4.850"
vols="4.759 4.801 4.850"
#vols="4.65837 4.685 4.730"
#vols="4.575 4.600 4.625"

for j in $vols; do 
  cd $j
  clist=`echo C/100/y/*`
  c=0
  for i in $clist; do
    cd $i 
    newname=$(pwd | tail -c 12 | tr -dc '[:alnum:]\n\r')
    sed -i 's/xxnamexx/'$newname'/g' cx1run.pbs.20
    sed -e 's/ncpus=20/ncpus=16/g' cx1run.pbs.20 > cx1run.pbs.16
#    sed -i 's/#PBS -l walltime=12:00:00/#PBS -lwalltime=24:00:00/g' cx1run.pbs.16
    qsub cx1run.pbs.16
    cd $dir/$j
    let c=c+1
    echo $c 
    pwd
  done
  cd $dir
done
echo Carbon $done

