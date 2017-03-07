#!/bin/bash
list="0/ 1/ 10/ 100/ 11/ 12/ 13/ 14/ 15/ 2/ 20/ 25/ 3/ 30/ 35/ 4/ 40/ 45/ 5/ 50/ 55/ 6/ 60/ 65/ 7/ 70/ 75/ 8/ 80/ 85/ 9/ 90/ 95/"
for i in $list; do sed -i 's/SIGMA  = 0.276/SIGMA  = 0.328/g' $i/INCAR ; done
for i in $list; do sed -i 's/9.602/9.700/g' $i/POSCAR ; done
for i in $list; do cd $i ; rm *.e* *.o* DOSCAR EIGENVAL IBZKPT OSZICAR mpd2.logfile_tmellan* OUTCAR PCDAT WAVECAR vasprun.xml CHG* ; cd ../ ; done 
for i in $list; do sed -i 's/#PBS -N EIN4801/#PBS -N 2EIN4850/g' $i/cx1run.pbs.16 ; done
for i in $list; do cd $i ; qsub cx1run.pbs.16 ; cd ../ ; done
