#!/bin/bash

list="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"
#list="1"
dir=`pwd`
scale11=$(echo 'scale=14;sqrt(1/2)' |bc -l)
scale111=$(echo 'scale=14;sqrt(1/3)' |bc -l)

for i in $list; do 
  cd $i
  lineold=$(head -n 8 POSCARold | tail -n 1); var=$( echo $(head -n 8 POSCARold | tail -n 1 | awk '{print $1}')*$scale111 | bc -l); linenew=$(echo " " $var "" $var "" $var)
  echo $lineold ; echo $linenew
#  mv POSCAR POSCARold
  sed -e "s/$lineold/$linenew/g" POSCARold > POSCAR
  rm *.e* *.o* DOSCAR EIGENVAL IBZKPT OSZICAR mpd2.logfile_tmellan* OUTCAR PCDAT WAVECAR vasprun.xml CHG* 
  echo done $i
  cd $dir
done
echo done all
