#!/bin/bash

for i in {001..146}; do
  echo $i
  mkdir disp-00$i && cp POSCAR-00$i disp-00$i/ && cp INCAR KPOINTS POTCAR disp-00$i/ && cp disp-00$i/POSCAR-00$i disp-00$i/POSCAR 
done
echo done
