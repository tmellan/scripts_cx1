#!/bin/bash

cat>plotfile_vol<<!
set term x11 0

set title "UP-sampling = (E_DFT_high - E_DFT_high_ref) - (E_EAMpot - E_EAMpot_ref)"
set xlabel "T=760Kx5L, T=1900Kx5L, T=2500Kx5L, T=3200Kx5L, T=3805Kx5L with L={0,015,0.5,0.85,1}"
set ylabel "UP-sample (meV/atom)"
plot "out.UPvol00" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "4.685Ang", "out.UPvol01" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "4.730Ang", "out.UPvol02" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "4.759Ang", "out.UPvol03" u 1:5 ps 2, "" u 1:5 w l lw 1 lt 1 title "4.801Ang", "out.UPvol04" u 1:5 ps 2, "" u 1:5 w l lw 1 lt 1 title "4.850Ang"


set term x11 1
set title "UP_EAMpot referenced to  zero T structure (E_EAMpot - E_EAMpot_ref)"
plot "out.UPvol00" u 1:4 ps 5, "" u 1:4 w l lw 1 lt 1 title "4.685Ang", "out.UPvol01" u 1:4 ps 5, "" u 1:4 w l lw 1 lt 1 title "4.730Ang", "out.UPvol02" u 1:4 ps 5, "" u 1:4 w l lw 1 lt 1 title "4.759Ang", "out.UPvol03" u 1:4 ps 2, "" u 1:4 w l lw 1 lt 1 title "4.801Ang", "out.UPvol04" u 1:4 ps 2, "" u 1:4 w l lw 1 lt 1 title "4.850Ang"


set term x11 2

set title "UP_DFT_high referenced zero T structure (E_DFT_high - E_DFT_high_ref)"
plot "out.UPvol00" u 1:3 ps 5, "" u 1:3 w l lw 1 lt 1 title "4.685Ang", "out.UPvol01" u 1:3 ps 5, "" u 1:3 w l lw 1 lt 1 title "4.730Ang", "out.UPvol02" u 1:3 ps 5, "" u 1:3 w l lw 1 lt 1 title "4.759Ang", "out.UPvol03" u 1:3 ps 2, "" u 1:3 w l lw 1 lt 1 title "4.801Ang", "out.UPvol04" u 1:3 ps 2, "" u 1:3 w l lw 1 lt 1 title "4.850Ang"
!

cat>plotfile_temp<<!
set term x11 3

set title "UP-sampling = (E_DFT_high - E_DFT_high_ref) - (E_EAMpot - E_EAMpot_ref)"
set xlabel "4.685Angx5L, 4.730Angx5L, 4.759Angx5L, 4.801Angx5L, 4.850Angx5L with L={0,015,0.5,0.85,1}"
set ylabel "UP-sample (meV/atom)"
plot "out.UPtemp760" u 1:6 ps 5, "" u 1:6 w l lw 1 lt 1 title "T=760K", "out.UPtemp1900" u 1:6 ps 5, "" u 1:6 w l lw 1 lt 1 title "T=1900K", "out.UPtemp2500" u 1:6 ps 5, "" u 1:6 w l lw 1 lt 1 title "T=2500K", "out.UPtemp3200" u 1:6 ps 2, "" u 1:6 w l lw 1 lt 1 title "T=3200K", "out.UPtemp3805" u 1:6 ps 2, "" u 1:6 w l lw 1 lt 1 title "T=3805K"


set term x11 4
set title "UP_EAMpot referenced to  zero T structure (E_EAMpot - E_EAMpot_ref)"
plot "out.UPtemp760" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "T=760K", "out.UPtemp1900" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "T=1900K", "out.UPtemp2500" u 1:5 ps 5, "" u 1:5 w l lw 1 lt 1 title "T=2500K", "out.UPtemp3200" u 1:5 ps 2, "" u 1:5 w l lw 1 lt 1 title "T=3200K", "out.UPtemp3805" u 1:5 ps 2, "" u 1:5 w l lw 1 lt 1 title "T=3805K"


set term x11 5

set title "UP_DFT_high referenced zero T structure (E_DFT_high - E_DFT_high_ref)"
plot "out.UPtemp760" u 1:3 ps 4, "" u 1:4 w l lw 1 lt 1 title "T=760K", "out.UPtemp1900" u 1:4 ps 5, "" u 1:4 w l lw 1 lt 1 title "T=1900K", "out.UPtemp2500" u 1:4 ps 5, "" u 1:4 w l lw 1 lt 1 title "T=2500K", "out.UPtemp3200" u 1:4 ps 2, "" u 1:4 w l lw 1 lt 1 title "T=3200K", "out.UPtemp3805" u 1:4 ps 2, "" u 1:4 w l lw 1 lt 1 title "T=3805K"
!

gnuplot -persist plotfile_vol

gnuplot -persist plotfile_temp
