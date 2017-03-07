#!/bin/bash

rm E0 index energy_displacement reference index_minus energy_displacement_plus energy_displacement_minus

list="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"

for i in $list; do 
  echo 'scale=5;'$i'*9.700/1000' | bc >> index
  echo 'scale=5;'$i'*-9.700/1000' | bc >> index_minus
  grep "E0= " 0/OSZICAR | awk '{print($5)}' >> reference
  grep "E0= " $i/OSZICAR | awk '{print($5)}' >> E0
done

paste E0 reference | awk '{print(1000*($1-$2))}' > E0_ref


paste index E0_ref > energy_displacement_plus
paste index_minus E0_ref > energy_displacement_minus
cat energy_displacement_minus energy_displacement_plus | sort -g > energy_displacement

cat >plotfile<<!
set terminal postscript eps color enhanced
set output 'Tel_3200_0.276_einstein.eps'
set multiplot

set arrow from 0.0,1000 to 0.0,6000 lw 1 back filled
set arrow from -0.2,1000 to 0.2,1000 lw 1 front nohead
set arrow from -0.2,-500 to 0.2,-500 lw 1 front nohead
set arrow from -0.2,1000 to -0.2,-500 lw 1 front nohead
set arrow from 0.2,1000 to 0.2,-500 lw 1 front nohead

set title "Anharmonic potential for large \n Zr displacement along <100>"
set xlabel "Equilibrium displacement (Angstrom)"
set ylabel "Energy (meV/64atoms)"
set xrange [-1.1:1.1]
set yrange [-1000:17000]

plot "energy_displacement" u 1:2 w l lw 2 title "", "" u 1:2 ps 1 pt 6 title "Potential"

set size 0.56,0.5
set origin 0.238,0.4
set title 'Harmonic region'
set xrange [-0.17:0.17]
set yrange [-200:400]
set xlabel ""
set ylabel ""
unset arrow
set grid

plot "energy_displacement" u 1:2 w l lw 2 title "", "" u 1:2 ps 2 pt 6 title "Potential"

unset multiplot


!
gnuplot -persist plotfile
