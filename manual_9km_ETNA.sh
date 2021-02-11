
#!/bin/bash

source /home/colombo/WRF/Build_WRF/SCRIPT_CHEM/setvar.sh

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

sed -i "s/end_date   = '.*',/end_date   = '2020-04-20_00:00:00',/g" namelist.wps
sed -i "s/start_date   = '.*',/start_date   = '2020-04-19_00:00:00',/g" namelist.wps

sed -i "s/start_year.*,/start_year = 2020,/g" namelist.input
sed -i "s/end_year.*,/end_year = 2020,/g" namelist.input
sed -i "s/start_month .*,/start_month = 04,/g" namelist.input
sed -i "s/start_day .*,/start_day = 19,/g" namelist.input
sed -i "s/start_hour .*,/start_hour = 00,/g" namelist.input
sed -i "s/end_month .*,/end_month = 04,/g" namelist.input
sed -i "s/end_day .*,/end_day = 20,/g" namelist.input
sed -i "s/end_hour .*,/end_hour = 00,/g" namelist.input

echo "START UNGRIB.EXE FOR GFS DATA: `date +%Y-%m-%d_%H:%M:%S` " 
ln -sf $WPS/ungrib/Variable_Tables/Vtable.GFS Vtable
./link_grib.csh $GRIBS/20200419-00/gfs
export LD_LIBRARY_PATH=/home/colombo/WRF/Build_WRF/LIBRARIES/grib2/lib
./$WPS/ungrib.exe

echo "START UNGRIB.EXE FOR SST DATA: `date +%Y-%m-%d_%H:%M:%S` " 
sed -i "s/prefix = 'FILE',/prefix = 'SST',/g" namelist.wps
sed -i "s/start_date = '.*',/start_date = '2020-04-19_00:00:00',/g" namelist.wps
ln -sf $WPS/ungrib/Variable_Tables/Vtable.SST Vtable
./link_grib.csh $GRIBS/20200419-00/rtg
./$WPS/ungrib.exe

sed -i "s/prefix = 'SST',/prefix = 'FILE',/g" namelist.wps
echo "START METGRID.EXE: `date +%Y-%m-%d_%H:%M:%S` " 
sed -i "s/start_date = '.*',/start_date = '2020-04-19_00:00:00',/g" namelist.wps
./$WPS/metgrid.exe

# ESECUZIONE DEL REAL CON LA CHEM ZERO

./real.exe

# PREPARAZIONE DEI DATI CHEM DEL DOMINIO 1

cd /home/colombo/WRF/CHEM/PREP-CHEM/bin
cp prep_chem_sources.inp.ETNA_2020 prep_chem_sources.inp
#rm *.ctl
#rm *.gra
#rm *.vfm
sed -i "s/ihour=.*,/ihour=00,/g" prep_chem_sources.inp
sed -i "s/iday=.*,/iday=19,/g" prep_chem_sources.inp
sed -i "s/imon=.*,/imon=04,/g" prep_chem_sources.inp
sed -i "s/iyear=.*,/iyear=2020,/g" prep_chem_sources.inp
sed -i "s/begin_eruption=.*,/begin_eruption='202004190600',/g" prep_chem_sources.inp

cp Values_19.txt Values.txt

./prep_chem_sources_RADM_WRF_FIM_.exe >& log9km.txt 
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
#TEST PER 4 BIN
#sed -i "s/chem_opt .*,/chem_opt = 403,/g" namelist.input

./real.exe
wait

mpirun -np 24 ./wrf.exe
wait

#cd $SCRIPTS
#./runNCL_ETNA.sh

#wait
# AVVIO DELLO SCRIPT NDOWN
#cd $SCRIPTS
#./Ndown.sh 00

#wait

#./build_em_nest.sh 00
cd $SCRIPTS
#./2020_ETNA.sh $1 $2 

exit

