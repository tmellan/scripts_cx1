!/bin/bash

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
#list="_100 _95 _90 _85 _80 _75 _70 _65 _60 _55 _50 _45 _40 _35 _30 _25 _20 _15 _14 _13 _12 _11 _10 _9 _8 _7 _6 _5 _4 _3 _2 _1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"
dir=`pwd`
c=0
elements="Zr C"
vols="4.65837 4.685 4.730 4.759 4.801 4.850"
#vols="4.575 4.600 4.625"

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
# Zr displacement options :  1=100 dx, 2=100 dy, 3=110 dxz, 4=110 dyz, 5=111 dxyz
#for Carbon,mkdir directories for the displacement direction and defect-symmetry-broken inequivalent displacements direction subdirs    
#      mkdir Zr ; cd Zr 
#        mkdir 100 110 111
#          cd 100 ; mkdir x y ; cd ../
#          cd 110 ; mkdir xz yz ; cd ../
#          cd 111 ; mkdir xyz  ; cd ../
#      cd $dir/$k/SETUPfiles

# C displacement options :  1=100 dx, 2=110 dxy, 3=110 dxz, 4=111 dxyz, 5=111 d-x+y+z ( bar on the x - necessarily after inorder to use mkdir in the directory name)
#for Zirconium, mkdir directories for the displacement direction and defect-symmetry-broken inequivalent displacements direction subdirs    
#      mkdir C ; 
        cd C 
#        mkdir 100 110 111
          cd 100 ; mkdir y ; cd ../
#          cd 100 ; mkdir x ; cd ../
#          cd 110 ; mkdir xy xz ; cd ../
#          cd 111 ; mkdir xyz ; mkdir  bxyz ; cd ../
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
    dX=$(echo "scale=9; $i*0.0001*$alatt" | bc -l)
    dY=$(echo "scale=9; $i*0.0001*$alatt" | bc -l)
    dZ=$(echo "scale=9; $i*0.0001*$alatt" | bc -l)
echo "6a) Got dx dy and dz"

#Zr displacements
#Make Zr new coords for 100 displacement
    zrXnew100=$(echo "scale=9; $scale1*$dX + $zrX" | bc -l)
    zrYnew100=$(echo "scale=9; $scale1*$dY + $zrY" | bc -l)
    zrZnew100=$(echo "scale=9; $scale1*$dZ + $zrZ" | bc -l)
#Make Zr new coords for 110 displacement
    zrXnew110=$(echo "scale=9; $scale2*$dX + $zrX" | bc -l)
    zrYnew110=$(echo "scale=9; $scale2*$dY + $zrY" | bc -l)
    zrZnew110=$(echo "scale=9; $scale2*$dZ + $zrZ" | bc -l)
#Make Zr new coords for 110 displacement
    zrXnew111=$(echo "scale=9; $scale3*$dX + $zrX" | bc -l)
    zrYnew111=$(echo "scale=9; $scale3*$dY + $zrY" | bc -l)
    zrZnew111=$(echo "scale=9; $scale3*$dZ + $zrZ" | bc -l)
echo "6b) Got Zr displacements"

#Make C new coords for 100 displacement
    cXnew100=$(echo "scale=9; $scale1*$dX + $cX" | bc -l)
    cYnew100=$(echo "scale=9; $scale1*$dY + $cY" | bc -l)
    cZnew100=$(echo "scale=9; $scale1*$dZ + $cZ" | bc -l)
echo "6c) Got C 100 displacements"
#Make C new coords for 110 displacement
    cXnew110=$(echo "scale=9; $scale2*$dX + $cX" | bc -l)
    cYnew110=$(echo "scale=9; $scale2*$dY + $cY" | bc -l)
    cZnew110=$(echo "scale=9; $scale2*$dZ + $cZ" | bc -l)
echo "6d) Got C 110 displacements"
#Make C new coords for 110 displacement
    cXnew111=$(echo "scale=9; $scale3*$dX + $cX" | bc -l)
    cXnew111bar=$(echo "scale=9; -1*$scale3*$dX + $cX" | bc -l)
    cYnew111=$(echo "scale=9; $scale3*$dY + $cY" | bc -l)
    cZnew111=$(echo "scale=9; $scale3*$dZ + $cZ" | bc -l)
echo "6e) Got C 111 displacements"


echo "7) defined new x y and z coords for displacement" $i

#Make new  Zr lines
    zrlinenewdx=$(echo " " $zrXnew100 "" $zrY "" $zrZ) && echo $zrlinenewdx > zrlinenewdx
    zrlinenewdy=$(echo " " $zrX "" $zrYnew100 "" $zrZ) && echo $zrlinenewdy > zrlinenewdy
    zrlinenewdxz=$(echo " " $zrXnew110 "" $zrY"" $zrZnew110) && echo $zrlinenewdxz > zrlinenewdxz
    zrlinenewdyz=$(echo " " $zrX "" $zrYnew110 "" $zrZnew110) && echo $zrlinenewdyz > zrlinenewdyz
    zrlinenewdxyz=$(echo " " $zrXnew111 "" $zrYnew111 "" $zrZnew111) && echo $zrlinenewdxyz > zrlinenewdxyz
#Make new C lines
    clinenewdx=$(echo " " $cXnew100 "" $cY "" $cZ) && echo $clinenewdx > clinenewdx
    clinenewdy=$(echo " " $cX "" $cYnew100 "" $cZ) && echo $clinenewdy > clinenewdy
    clinenewdxy=$(echo " " $cXnew110 "" $cYnew110 "" $cZ) && echo $clinenewdxy > clinenewdxy
    clinenewdxz=$(echo " " $cXnew110 "" $cY "" $cZnew110) && echo $clinenewdxz > clinenewdxz
    clinenewdxyz=$(echo " " $cXnew111 "" $cYnew111 "" $cZnew111) && echo $clinenewdxyz > clinenewdxyz
    clinenewdbxyz=$(echo " " $cXnew111bar "" $cYnew111 "" $cZnew111) && echo $clinenewdbxyz > clinenewdbxyz

echo "8) Have exported new coordinate lines for displacement" $i

#Make the new POSCAR for Zr disp
# Zr displacement options :  1=100 dx, 2=100 dy, 3=110 dxz, 4=110 dyz, 5=111 dxyz
    cat head zrlinenewdx zmidSection    > $dir/$k/SETUPfiles/Zr/100/x/POSCAR.$i
    cat head zrlinenewdy zmidSection    > $dir/$k/SETUPfiles/Zr/100/y/POSCAR.$i
    cat head zrlinenewdxz zmidSection   > $dir/$k/SETUPfiles/Zr/110/xz/POSCAR.$i
    cat head zrlinenewdyz zmidSection   > $dir/$k/SETUPfiles/Zr/110/yz/POSCAR.$i
    cat head zrlinenewdxyz zmidSection  > $dir/$k/SETUPfiles/Zr/111/xyz/POSCAR.$i
#Make the new POSCAR for Zr disp
# C displacement options :  1=100 dx, 2=NA-, 3=110 dxy, 4=110 dxz, 5=111 dxyz, 6=111 d-x+y+z (bar before the x)
    cat head cmidSection clinenewdx     > $dir/$k/SETUPfiles/C/100/x/POSCAR.$i
    cat head cmidSection clinenewdy     > $dir/$k/SETUPfiles/C/100/y/POSCAR.$i
    cat head cmidSection clinenewdxy    > $dir/$k/SETUPfiles/C/110/xy/POSCAR.$i
    cat head cmidSection clinenewdxz    > $dir/$k/SETUPfiles/C/110/xz/POSCAR.$i
    cat head cmidSection clinenewdxyz   > $dir/$k/SETUPfiles/C/111/xyz/POSCAR.$i
    cat head cmidSection clinenewdbxyz  > $dir/$k/SETUPfiles/C/111/bxyz/POSCAR.$i

echo "9) Exported POSCAR for Zr and C for each direction and displacement for displacement index" $i

    cd $dir/$k/SETUPfiles
  done

echo "10) Finished all the displacement loops for for volume " $k

  cd $dir
done

echo "11) FINISHED ALL PART1"

echo "12) PART2 - make directories for calcualtions"

for k in $vols; do
 cd $dir/$k
    mkdir Zr ; cd Zr
      mkdir 100 110 111
        cd 100 ; mkdir x y ; cd ../
        cd 110 ; mkdir xz yz ; cd ../
        cd 111 ; mkdir xyz  ; cd ../
  cd $dir/$k
    mkdir C ; cd C
      mkdir 100 110 111
        cd 100 ; mkdir x y ; cd ../
        cd 110 ; mkdir xy xz ; cd ../
        cd 111 ; mkdir xyz ; mkdir  bxyz ; cd ../
  cd $dir/$k
done
cd $dir

echo "13) Done PART 2 -  making calculation directory stucture"

echo "14) PART 3 - putting stuff in calculation dirs"

for k in $vols; do
  cd $dir/$k
  for j in $elements; do 
    cd $dir/$k/$j 
    paths=`echo */*`
    for p in $paths; do 
      cd $p
      for i in $list; do

        if [ $i -le -1 ]; then
          pm="m" ; h=`echo "-1*$i" | bc -l`
        else
          pm="p" ; h=`echo "1*$i" | bc -l`
        fi
   
        mkdir $pm$h
        cd $pm$h
        cp $dir/$k/SETUPfiles/$j/$p/POSCAR.$i .
        cp POSCAR.$i POSCAR
        cp $dir/calcSUBSTUFF/* .
        cd $dir/$k/$j/$p/
      done
      cd $dir/$k/$j
    done
    cd $dir/$k
  done
  cd $dir
done
echo "DONE PART 3"

echo "########################### FINISHED #########################"
