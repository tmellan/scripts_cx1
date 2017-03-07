#!/bin/bash

rm E0 index energy_MOD reference

list="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"

for i in {001..017}; do 
#  echo 'scale=5;'$i'*9.370/1000' | bc >> index
#  echo 'scale=5;'$i'*-9.370/1000' | bc >> index_minus
  echo $i >> index
  grep "E0= " 009/OSZICAR | awk '{print($5)}' >> reference
  grep "E0= " $i/OSZICAR | awk '{print($5)}' >> E0
done

paste E0 reference | awk '{print(1000*($1-$2))}' > E0_ref


paste index_1 E0_ref | column -t > energy_MOD
#paste index_minus E0_ref > energy_displacement_minus
#cat energy_displacement_minus energy_displacement_plus | sort -g > energy_displacement

cat >plotfile<<!
set terminal postscript eps color enhanced
set output 'Band4_AmpModulation.eps'
set multiplot

set arrow from 0.0,10 to 0.0,400 lw 1 back filled
#set arrow from -0.2,1000 to 0.2,1000 lw 1 front nohead
#set arrow from -0.2,-500 to 0.2,-500 lw 1 front nohead
#set arrow from -0.2,1000 to -0.2,-500 lw 1 front nohead
#set arrow from 0.2,1000 to 0.2,-500 lw 1 front nohead

set title "ZrC band 4 X amplitude modulation"
set xlabel "Amplitude (Angstrom/sqrt(amu))"
set ylabel "Energy (meV/64atoms)"
#set xrange [-1.1:1.1]
#set yrange [-1000:17000]

plot "energy_MOD" u 1:2 w l lw 2 title "", "" u 1:2 ps 1 pt 6 title "Potential"

set size 0.56,0.5
set origin 0.238,0.4
set title 'Harmonic region'
set xrange [-16:16]
set yrange [0:200]
set xlabel ""
set ylabel ""
unset arrow
set grid

plot "energy_MOD" u 1:2 w l lw 2 title "", "" u 1:2 ps 2 pt 6 title "Potential"

unset multiplot


!
gnuplot -persist plotfile
