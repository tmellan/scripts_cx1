#!/bin/bash

dir=`pwd`
dirs="4.685  4.730  4.759  4.801  4.850"
rm all_E0_val

for i in $dirs; do
  cd $i && grep E0= OSZICAR | awk '{print $5}' > E0_val && cat E0_val >> ../all_E0_val && cd $dir
done

tail -1 RELAX_full/OSZICAR | awk '{print $5}' > RELAX_full/E0_val && cat RELAX_full/E0_val >> all_E0_val

echo done 
