#!/bin/bash

rm force_x index_f force_displacement index_minus_f force_displacement_plus force_x_minus force_displacement_minus

list="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"

for i in $list; do 
  tail -n 118 $i/OUTCAR | sed -n 1p | awk '{print $4}' >> force_x
  tail -n 118 $i/OUTCAR | sed -n 1p | awk '{print -1*$4}' >> force_x_minus
  echo 'scale=5;'$i'*9.685/1000' | bc >> index_f
  echo 'scale=5;'$i'*-9.685/1000' | bc >> index_minus_f
done



paste index_f force_x > force_displacement_plus
paste index_minus_f force_x_minus > force_displacement_minus
cat force_displacement_minus force_displacement_plus | sort -g > force_displacement

#cat >plotfile<<!
#set terminal postscript eps color enhanced
#set output 'Tel_300_0.026_einstein.eps'
#set multiplot
#
#set arrow from 0.0,1000 to 0.0,6000 lw 1 back filled
set arrow from -0.2,1000 to 0.2,1000 lw 1 front nohead
set arrow from -0.2,-500 to 0.2,-500 lw 1 front nohead
set arrow from -0.2,1000 to -0.2,-500 lw 1 front nohead
set arrow from 0.2,1000 to 0.2,-500 lw 1 front nohead

set title "Anharmonic potential for large \n Zr displacement along <100>"
set xlabel "Equilibrium displacement (Angstrom)"
set ylabel "Energy (meV/64atoms)"
set xrange [-1.1:1.1]
set yrange [-1000:17000]

#plot "energy_displacement" u 1:2 w l lw 2 title "", "" u 1:2 ps 1 pt 6 title "Potential"

set size 0.56,0.5
set origin 0.238,0.4
set title 'Harmonic region'
set xrange [-0.17:0.17]
set yrange [-200:400]
set xlabel ""
set ylabel ""
unset arrow
set grid

#plot "energy_displacement" u 1:2 w l lw 2 title "", "" u 1:2 ps 2 pt 6 title "Potential"

#unset multiplot


#!
#gnuplot -persist plotfile
