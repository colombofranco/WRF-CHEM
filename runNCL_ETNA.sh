#!/bin/bash

source /home/colombo/WRF/WRF_IFORT/SCRIPT/setvar.sh
export NCARG_ROOT=/home/colombo/NCL
export PATH=$NCARG_ROOT/bin:$PATH

. $SCRIPTS/setdatechem.sh

cd /home/colombo/WRF/Build_WRF/script_NCL/dust/
rm *.png

ncl ASH.ncl
ncl ash_3km_shape.ncl
ncl ASH_3km.ncl
ncl ASH_1km.ncl
ncl ASH_FALL1km.ncl
ncl ASH_FALL3km.ncl
wait
rm *000001.png

ls Etna_Fall_Out_1* | rename 's/.000002.png/.png/g'
ls Etna_Fall_Out_3* | rename 's/.000002.png/.png/g'
ls Etna_Ash_Cloud_3* | rename 's/.000002.png/.png/g'
ls Etna_Ash_Cloud_1* | rename 's/.000002.png/.png/g'
mv Etna_Ash_Cloud_3km1.png Etna_Ash_Cloud_3km01.png
mv Etna_Ash_Cloud_3km2.png Etna_Ash_Cloud_3km02.png
mv Etna_Ash_Cloud_3km3.png Etna_Ash_Cloud_3km03.png
mv Etna_Ash_Cloud_3km4.png Etna_Ash_Cloud_3km04.png
mv Etna_Ash_Cloud_3km5.png Etna_Ash_Cloud_3km05.png
mv Etna_Ash_Cloud_3km6.png Etna_Ash_Cloud_3km06.png
mv Etna_Ash_Cloud_3km7.png Etna_Ash_Cloud_3km07.png
mv Etna_Ash_Cloud_3km8.png Etna_Ash_Cloud_3km08.png
mv Etna_Ash_Cloud_3km9.png Etna_Ash_Cloud_3km09.png

mv Etna_Ash_Cloud_1km1.png Etna_Ash_Cloud_1km01.png
mv Etna_Ash_Cloud_1km2.png Etna_Ash_Cloud_1km02.png
mv Etna_Ash_Cloud_1km3.png Etna_Ash_Cloud_1km03.png
mv Etna_Ash_Cloud_1km4.png Etna_Ash_Cloud_1km04.png
mv Etna_Ash_Cloud_1km5.png Etna_Ash_Cloud_1km05.png
mv Etna_Ash_Cloud_1km6.png Etna_Ash_Cloud_1km06.png
mv Etna_Ash_Cloud_1km7.png Etna_Ash_Cloud_1km07.png
mv Etna_Ash_Cloud_1km8.png Etna_Ash_Cloud_1km08.png
mv Etna_Ash_Cloud_1km9.png Etna_Ash_Cloud_1km09.png
#UPLOADING MAP (MAPPE NCL)
ncftp -u 184408@aruba.it -p i2rveClivio www.meteorologia.it  << EOT
cd meteorologia.it/wrf_sicilia/
lcd /home/colombo/WRF/Build_WRF/script_NCL/dust
put -f *.png
bye
EOT

mkdir $ARCHIVE_IMAGES/NCL/ASH/$start_year$start_month$start_day-00

mv *.png $ARCHIVE_IMAGES/NCL/ASH/$start_year$start_month$start_day-00


