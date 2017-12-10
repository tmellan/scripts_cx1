#!/bin/bash

#########################################
#Script to set up files for displacements 
#in an uncoupled anharmonic Einstein 
#model about a vacancy defect in ZrC
#########################################

#Options:
#Element type - Zr or C
#TYPE="Zr"

#With vacancy symmetry, for 6Zr NN to C vac, 2 inequiv disp for 100, 2 for 110 and 1 for 111
# Zr displacement options :  1=100 dx, 2=100 dy, 3=110 dxz, 4=110 dyz, 5=111 dxyz
#zoption="1"
#With vacancy symmetry, for 12 C NN to C vac, 1 inequiv disp for 100, 2 for 110 and 2 for 111
# C displacement options :  1=100 dx, 2=110 dxy, 3=110 dxz, 4=111 dxyz, 5=111 d-x+y+z
#coption="1"

#Standard bla
list="-100 -95 -90 -85 -80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"
dir=`pwd`
#vols="4.575 4.600 4.625 4.65837 4.685 4.730 4.759 4.801 4.850"
vols="4.65837"

#Define geometry parameters for x xy and xyz direction displacements
scale1=$(echo 'scale=14;sqrt(1/1)' |bc -l)
scale2=$(echo 'scale=14;sqrt(1/2)' |bc -l)
scale3=$(echo 'scale=14;sqrt(1/3)' |bc -l)

#Note  a direction for Zr disp is toward outplane vac, b and c are 'inplane'
#Max dispacement at 100 is 0.1000000000000000 or alatt/10 angstrom

##########################################################
#Main loop to make calculation folders and put the deformation lattice POSCARs in
##########################################################

echo "1) entering main loop"

for k in $vols; do

#Get the structure for this volume, move into a subdir for the volume, and make a folder where all the setup files (dsiplacements and strucutres) can go   
  mkdir $k/
  cd $k/
  mkdir SETUPfiles
  cp $dir/SUBSTUFF/POSCARs/rearr_POSCAR.$k SETUPfiles/POSCARworking
  cd $dir/$k/SETUPfiles

echo "2) made setupfiles directory for volume" $k

#for Carbon,mkdir directories for the displacement direction and defect-symmetry-broken inequivalent displacements direction subdirs    
      mkdir Zr && cd Zr 
        mkdir 100 110 111
          cd 100 && mkdir x y && cd ../
          cd 110 && mkdir xz yz && cd ../
          cd 111 && mkdir xyz && cd ../
      cd $dir/$k/SETUPfiles

#for Zirconium, mkdir directories for the displacement direction and defect-symmetry-broken inequivalent displacements direction subdirs    
      mkdir C && cd C 
        mkdir 100 110 111
          cd 100 && mkdir x y && cd ../
          cd 110 && mkdir xz yz && cd ../
          cd 111 && mkdir xyz && cd ../
      cd $dir/$k/SETUPfiles

echo "3) direction and displacement subdirerctories made"

#extract the parts of the POSCAR not changing
  sed -n '1,8p' POSCARworking > head
  sed -n '10,70p' POSCARworking > midSection
  sed -n '10,71p' POSCARworking > zmidSection
  sed -n '9,70p' POSCARworking > cmidSection

echo "4) POSCAR broken up into parts"

#Get lattice parameter
  alatt=$(sed -n '3,3p' POSCARworking | awk '{print $1}')

#Get C zr x y z coords
  zrX=$(sed -n '9,9p' POSCARworking | awk '{print $1}') 
  zrY=$(sed -n '9,9p' POSCARworking | awk '{print $2}') 
  zrZ=$(sed -n '9,9p' POSCARworking | awk '{print $3}') 
#Get C zr x y z coords
  cX=$(sed -n '71,71p' POSCARworking | awk '{print $1}')
  cY=$(sed -n '71,71p' POSCARworking | awk '{print $2}')
  cZ=$(sed -n '71,71p' POSCARworking | awk '{print $3}')

echo "6) extract variables for Zr and C x y and z coordinates of atom being displaced - entering displacement loop"

  for i in $list; do

#Get dx dy dz
    dX=$(echo "scale=9; $i*0.001*$alatt" | bc -l)
    dY=$(echo "scale=9; $i*0.001*$alatt" | bc -l)
    dZ=$(echo "scale=9; $i*0.001*$alatt" | bc -l)

#Make Zr new coords for 100 displacement
    zrXnew100=$(echo "scale=9; $dX + $scale1*$zrX" | bc -l)
    zrYnew100=$(echo "scale=9; $dY + $scale1*$zrY" | bc -l)
    zrZnew100=$(echo "scale=9; $dZ + $scale1*$zrZ" | bc -l)
#Make Zr new coords for 110 displacement
    zrXnew110=$(echo "scale=9; $dX + $scale2*$zrX" | bc -l)
    zrYnew110=$(echo "scale=9; $dY + $scale2*$zrY" | bc -l)
    zrZnew110=$(echo "scale=9; $dZ + $scale2*$zrZ" | bc -l)
#Make Zr new coords for 110 displacement
    zrXnew111=$(echo "scale=9; $dX + $scale3*$zrX" | bc -l)
    zrYnew111=$(echo "scale=9; $dY + $scale3*$zrY" | bc -l)
    zrZnew111=$(echo "scale=9; $dZ + $scale3*$zrZ" | bc -l)

#Make C new coords for 100 displacement
    cXnew100=$(echo "scale=9; $dX + $scale1*$cX" | bc -l)
    cYnew100=$(echo "scale=9; $dY + $scale1*$cY" | bc -l)
    cZnew100=$(echo "scale=9; $dZ + $scale1*$cZ" | bc -l)
#Make C new coords for 110 displacement
    cXnew110=$(echo "scale=9; $dX + $scale2*$cX" | bc -l)
    cYnew110=$(echo "scale=9; $dY + $scale2*$cY" | bc -l)
    cZnew110=$(echo "scale=9; $dZ + $scale2*$cZ" | bc -l)
#Make C new coords for 110 displacement
    cXnew111=$(echo "scale=9; $dX + $scale3*$cX" | bc -l)
    cYnew111=$(echo "scale=9; $dY + $scale3*$cY" | bc -l)
    cZnew111=$(echo "scale=9; $dZ + $scale3*$cZ" | bc -l)

echo "7) defined new x y and z coords for displacement" $i

#Make new  Zr lines
    zrlinenewdx=$(echo " " $zrXnew100 "" $zrY "" $zrZ) && echo $zrlinenewdx > zrlinenewdx
    zrlinenewdy=$(echo " " $zrX "" $zrYnew100 "" $zrZ) && echo $zrlinenewdy > zrlinenewdy
    zrlinenewdxz=$(echo " " $zrXnew110 "" $zrYnew110 "" $zrZ) && echo $zrlinenewdxz > zrlinenewdxz
    zrlinenewdyz=$(echo " " $zrX "" $zrYnew110 "" $zrZnew110) && echo $zrlinenewdyz > zrlinenewdyz
    zrlinenewdxyz=$(echo " " $zrXnew111 "" $zrYnew111 "" $zrZnew111) && echo $zrlinenewdxyz > zrlinenewdxyz
#Make new C lines
    clinenewdx=$(echo " " $cXnew "" $cY "" $cZ) && echo $clinenewdx > clinenewdx
    clinenewdy=$(echo " " $cX "" $cYnew "" $cZ) && echo $clinenewdy > clinenewdy
    clinenewdxz=$(echo " " $cXnew110 "" $cYnew110 "" $cZ) && echo $clinenewdxz > clinenewdxz
    clinenewdyz=$(echo " " $cX "" $cYnew110 "" $cZnew110) && echo $clinenewdyz > clinenewdyz
    clinenewdxyz=$(echo " " $cXnew111 "" $cYnew111 "" $cZnew111) && echo $clinenewdxyz > clinenewdxyz

echo "8) Have exported new coordinate lines for displacement" $i

#Make the new POSCAR for Zr disp
# Zr displacement options :  1=100 dx, 2=100 dy, 3=110 dxz, 4=110 dyz, 5=111 dxyz
    cat head zrlinenewdx zmidSection    > $dir/$k/SETUPfilesz/Zr/100/x/POSCAR.$i
    cat head zrlinenewdy zmidSection    > $dir/$k/SETUPfilesz/Zr/100/y/POSCAR.$i
    cat head zrlinenewdxz zmidSection   > $dir/$k/SETUPfilesz/Zr/110/xz/POSCAR.$i
    cat head zrlinenewdyz zmidSection   > $dir/$k/SETUPfilesz/Zr/110/yz/POSCAR.$i
    cat head zrlinenewdxyz zmidSection  > $dir/$k/SETUPfilesz/Zr/111/xyz/POSCAR.$i
#Make the new POSCAR for Zr disp
# C displacement options :  1=100 dx, 2=NA-, 3=110 dxy, 4=110 dxz, 5=111 dxyz, 6=111 d-x+y+z
    cat head cmidSection clinenewdx     > $dir/$k/SETUPfilesc/C/100/x/POSCAR.$i
    cat head cmidSection clinenewdxy    > $dir/$k/SETUPfilesc/C/110/xy/POSCAR.$i
    cat head cmidSection clinenewdxz    > $dir/$k/SETUPfilesc/C/110/xz/POSCAR.$i
    cat head cmidSection clinenewdxyz   > $dir/$k/SETUPfilesc/C/111/xyz/POSCAR.$i
    cat head cmidSection clinenewd-xyz  > $dir/$k/SETUPfilesc/C/111/-xyz/POSCAR.$i

echo "9) Exported POSCAR for Zr and C for each direction and displacement for displacement index" $i

    cd $dir/$k/SETUPfiles
  done

echo "10) Finished all the displacement loops for for volume " $k

  cd $dir
done

echo "11) FINISHED ALL"
