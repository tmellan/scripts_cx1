#!/bin/bash

  rm partial_submitted partial_submitted_all doing_already
  for k in `echo 4.*_*`; do cd $k ;  if [ $(tail -n 2 OUTCAR | head -n 1 | head -c 5) == "m" ]; then echo $k ; else echo $k >> ../doing_already ; fi; cd ../ ; done  2>/dev/null > partial_submitted
  sleep 3
  echo $j $(cat partial_submitted) >> ../partial_submitted_all
  sleep 1
  dispList=`cat partial_submitted`

for i in $dispList; do 
  cd $i 
#  rm OS* OU* vaspr* *.o* *.e* 
  sed -i 's/ISYM   =     0/#ISYM=0/g' INCAR 
  sed -i 's/NBANDS = 384/NBANDS = 336/g' INCAR 
#  sed -i 's/EDIFF  =   1E-8/EDIFF = 1E-5/g' INCAR 
#  sed -i 's/LREAL =.FALSE./#LREAL =.FALSE./g' INCAR 
#  sed -i 's/select=2:ncpus=20:mem=20Gb/select=1:ncpus=16:mem=16Gb/g' cx1run.pbs.20  




  sed -i 's/#PBS -l select=1:ncpus=16:mem=16Gb/#PBS -l select=1:ncpus=16:mem=32Gb/g' cx1run.pbs.20  
  sed -i 's/#PBS -l walltime=48:00:00/#PBS -l walltime=24:00:00/g' cx1run.pbs.20  
  qsub cx1run.pbs.20
  cd ../  
done
