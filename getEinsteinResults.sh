#!/bin/bash

natoms=63

name="CVAC"
list="-100 -95 -90 -85 -80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"
dir=`pwd`
c=0
elements="Zr C"
vols="4.575 4.600 4.625 4.65837 4.685 4.730 4.759 4.801 4.850"
#vols="4.575"
#directions="100 110 111"

output=$(echo $name'_RESULTS')
rm -r $output ; mkdir $output

for j in $vols; do 

  alatt=$(echo "scale=9; $j*2" | bc -l)
 
  for e in $elements; do 
    e0perfect=$(tail -n 1 $j/$e/110/xz/p0/OSZICAR | awk '{printf "%.15g\n", $5}')
    frperfect=$(tail -n 1 $j/$e/110/xz/p0/OSZICAR | awk '{printf "%.15g\n", $3}')
    cd $j/$e ; directions=$(echo */*) ; cd $dir
    for d in $directions; do
      for i in $list; do

        disp=$(echo "scale=9; $i*0.001*$alatt" | bc -l)
        echo $disp >> $dir/$output/$name'_disp.Ang'

        if [ $i -le -1 ]; then
          pm="m" ; h=`echo "-1*$i" | bc -l`
        else
          pm="p" ; h=`echo "1*$i" | bc -l`
        fi
          
        cd $j/$e/$d/$pm$h

        folder=$(pwd)
        e0=$(tail -n 1 OSZICAR | awk '{printf "%.15g\n", $5}')
        fr=$(tail -n 1 OSZICAR | awk '{printf "%.15g\n", $3}')
        echo $folder $e0 >> $dir/$output/$name'_e0'
        echo $folder $fr >> $dir/$output/$name'_fr'
        echo $folder $e0perfect >> $dir/$output/$name'_e0perfect'
        echo $folder $frperfect >> $dir/$output/$name'_frperfect' 

        cd $dir
      done
    done
  done
done

head  $dir/$output/$name'_e0'
head  $dir/$output/$name'_fr'
head  $dir/$output/$name'_e0perfect'
head  $dir/$output/$name'_frperfect'

cd $dir/$output
paste <(awk '{printf "%.15g\n", $2}' $name'_e0') <(awk '{printf "%.15g\n", $2}' $name'_e0perfect') <(awk '{printf "%.15g\n", $2}' $name'_fr') <(awk '{printf "%.15g\n", $2}' $name'_frperfect') > tmp
awk '{$5=$1-$2}'1 tmp > tmp2
awk '{$6=$4-$3}'1 tmp2 > e0_e0perfect_fr_frperfect 
paste <(cat $name'_disp.Ang') <(awk '{printf "%.15g\n", 1000*$5/'$natoms'}' e0_e0perfect_fr_frperfect) > d_e0_meVatom.dat
paste <(cat $name'_disp.Ang') <(awk '{printf "%.15g\n", 1000*$6/'$natoms'}' e0_e0perfect_fr_frperfect) > d_fr_meVatom.dat
rm tmp*
echo ""
