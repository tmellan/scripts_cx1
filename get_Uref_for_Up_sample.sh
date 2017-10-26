maxval=50000
volumes="4685 4730 4759 4801 4850"
TEMPS="300 760 1900 2500 3200 3805"

configs=$(for i in {50..0}; do echo $maxval - $i*500 +1 | bc -l ; done)

dir=`pwd`
for i in $volumes; do 
  for j in $TEMPS; do 
    cd $i/$j/
    pwd
    for k in $configs; do sed -n $k'p' dUdL ; done | awk '{print $5}' | column -t > selected_Upot_UPsample
    cd $dir
  done
done

for i in $volumes; do  
  for j in $TEMPS; do

    paste <(cat DFT_RESULTS/$i.$j.e0) <(cat $i/$j/selected_Upot_UPsample) | awk '{$3=$2-$1}'1 | column -t > DFT_RESULTS/DFT_pot.$i.$j
    awk -v N=3 '{ sum += $N } END { if (NR > 0) print sum / NR }' DFT_RESULTS/DFT_pot.$i.$j
  done
done > DFT_RESULTS/col_correction

for i in $volumes; do
  for j in $TEMPS; do
    tail -n 1 $i/$j/dUdL | awk '{printf "%.9g\n", $9}'
  done
done > DFT_RESULTS/col_t_mvt_int_all

paste <(cat DFT_RESULTS/col_t_mvt_int_all) <(cat DFT_RESULTS/col_correction) | awk '{$3=$1-$2}'1 | column -t > DFT_RESULTS/Fah_Cor_NewFah
cat DFT_RESULTS/Fah_Cor_NewFah
