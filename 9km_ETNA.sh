
#!/bin/bash

source /home/colombo/WRF/Build_WRF/SCRIPT_CHEM/setvar.sh

DATE=`date +%Y%m%d`
RUN=$1
START_ERUPTION=$2
sstold=24
#hours3kmN=24   in tal modo ritorna 48 ore come in setvar

start_date_upp=`date "-d 3 hours ago" +%Y%m%d`"$RUN"
start_date=`date "-d 3 hours ago" +%Y-%m-%d_`"$RUN:00:00"
start_date_restart=`date "-d 3 hours ago" +%Y-%m-%d_`"01:00:00"
end_date=`date "-d $hours3kmN hours" +%Y-%m-%d_`"$RUN:00:00"

start_year=`date +%Y`
end_year=`date "-d $hours3kmN hours" +%Y`
start_month=`date +%m`
end_month=`date "-d $hours3kmN hours" +%m`
start_day=`date "-d 3 hours ago" +%d`
end_day=`date "-d $hours3kmN hours" +%d`
start_hour=$RUN
end_hour=$RUN
end_day_Nest=`date "-d $hours3kmN hours" +%d`

sst_date=`date "-d $sstold hours ago" +%Y-%m-%d_`"00:00:00"
sst_date_down=`date "-d $sstold hours ago" +%Y%m%d`"00"
sst_date_down_rtg=`date "-d $sstold hours ago" +%Y%m%d`
sst_date_down_y=`date "-d $sstold hours ago" +%Y`
sst_date_down_m=`date "-d $sstold hours ago" +%m`
sst_date_constant=`date "-d $sstold hours ago" +%Y-%m-%d_`"00"

#PULISCO LA DIRECTORY
cd $DIRECTORY_9KM
#rm wrfrst*
rm wrfinput*
rm wrfbdy*
rm SST:*
rm FILE:*
rm PFILE:*
rm met_em*
rm qr*
rm freeze*
rm rsl.error.*
rm rsl.out.*
rm wrfout_d01*
rm wrfchemv_d01

cp namelist.input.start namelist.input

sed -i "s/end_date   = '.*',/end_date   = '$end_date',/g" namelist.wps
sed -i "s/start_date   = '.*',/start_date   = '$start_date',/g" namelist.wps



sed -i "s/start_year.*,/start_year = $start_year,/g" namelist.input
sed -i "s/end_year.*,/end_year = $end_year,/g" namelist.input
sed -i "s/start_month .*,/start_month = $start_month,/g" namelist.input
sed -i "s/start_day .*,/start_day = $start_day,/g" namelist.input
sed -i "s/start_hour .*,/start_hour = $start_hour,/g" namelist.input
sed -i "s/end_month .*,/end_month = $end_month,/g" namelist.input
sed -i "s/end_day .*,/end_day = $end_day,/g" namelist.input
sed -i "s/end_hour .*,/end_hour = $end_hour,/g" namelist.input

ln -sf $WPS/ungrib/Variable_Tables/Vtable.GFS Vtable
./link_grib.csh $GRIBS/$start_year$start_month$start_day-$start_hour/gfs
export LD_LIBRARY_PATH=/home/colombo/WRF/Build_WRF/LIBRARIES/grib2/lib
./$WPS/ungrib.exe
wait

sed -i "s/prefix = 'FILE',/prefix = 'SST',/g" namelist.wps
sed -i "s/start_date = '.*',/start_date = '"$sst_date"',/g" namelist.wps
ln -sf $WPS/ungrib/Variable_Tables/Vtable.SST Vtable
./link_grib.csh $GRIBS/$start_year$start_month$start_day-$start_hour/$sstsource
./$WPS/ungrib.exe

sed -i "s/prefix = 'SST',/prefix = 'FILE',/g" namelist.wps
sed -i "s/start_date = '.*',/start_date = '$start_date',/g" namelist.wps
./$WPS/metgrid.exe

# ESECUZIONE DEL REAL CON LA CHEM ZERO

./real.exe

# PREPARAZIONE DEI DATI CHEM DEL DOMINIO 1

cd /home/colombo/WRF/Build_WRF/PREP-CHEM/bin
cp prep_chem_sources.inp.ETNA_2020 prep_chem_sources.inp
#rm *.ctl
#rm *.gra
#rm *.vfm
sed -i "s/ihour=.*,/ihour=$1,/g" prep_chem_sources.inp
sed -i "s/iday=.*,/iday=$start_day,/g" prep_chem_sources.inp
sed -i "s/imon=.*,/imon=$start_month,/g" prep_chem_sources.inp
sed -i "s/iyear=.*,/iyear=$start_year,/g" prep_chem_sources.inp
sed -i "s/begin_eruption=.*,/begin_eruption='$start_year$start_month$start_day$2',/g" prep_chem_sources.inp

cp Values_9km.txt Values.txt

./prep_chem_sources_RADM_WRF_FIM_SIMPLE.exe >& log9km.txt 
wait

mv *-g1-ab.bin /home/colombo/WRF/Build_WRF/ETNA_9KM/emissopt3_d01
mv *-g1-bb.bin /home/colombo/WRF/Build_WRF/ETNA_9KM/emissfire_d01
mv *-g1-gocartBG.bin /home/colombo/WRF/Build_WRF/ETNA_9KM/wrf_gocart_backg
mv *-g1-volc.bin /home/colombo/WRF/Build_WRF/ETNA_9KM/volc_d01
rm *.gra
rm *.ctl
rm *.vfm

cd $DIRECTORY_9KM


#ATTIVAZIONE DELLA CHEM

sed -i "s/io_form_auxinput2 .*,/io_form_auxinput2 = 2,/g" namelist.input
sed -i "s/io_form_auxinput13 .*,/io_form_auxinput13 = 2,/g" namelist.input
sed -i "s/chem_opt .*,/chem_opt = 401,/g" namelist.input
sed -i "s/emiss_opt_vol .*,/emiss_opt_vol = 2,/g" namelist.input
#sed -i "s/emiss_ash_hgt .*,/emiss_ash_hgt = $3,/g" namelist.input
#ESECUZIONE DEL CONVERT_EMISS CHE PRODUCE IL WRFCHEMV_D01

./convert_emiss.exe
wait

#CHEM PER EMISSIONE VULCANICA SUL DOMINIO 1
sed -i "s/chem_opt .*,/chem_opt = 402,/g" namelist.input

./real.exe
wait

mpirun -np 24 ./wrf.exe
wait

#cd /home/colombo/DATI/WRFOUT
#mv wrfout_ETNA9km_"$start_date_restart" wrfout_ETNA9km_"$start_date"
#wait
rm wrfrst_d01_$sst_date


cd $SCRIPTS
./2020_ETNA.sh $1 $2 

exit

