
#!/bin/bash

source /home/colombo/WRF/Build_WRF/SCRIPT_CHEM/setvar.sh

DATE=`date +%Y%m%d`
RUN=$1

sstold=24
#hours3kmN=24   in tal modo ritorna 48 ore come in setvar

start_date_upp=`date "-d 3 hours ago" +%Y%m%d`"$RUN"
start_date=`date "-d 3 hours ago" +%Y-%m-%d_`"$RUN:00:00"
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


cd $DIRECTORY_ETNA_1KM

rm wrf_gocart*
rm volc_d01*
rm emissfire*
rm emissopt3*
rm wrfchemv*

cp namelist.input.chem namelist.input

sed -i "s/start_year.*,/start_year = $start_year,/g" namelist.input
sed -i "s/end_year.*,/end_year = $end_year,/g" namelist.input
sed -i "s/start_month .*,/start_month = $start_month,/g" namelist.input
sed -i "s/start_day .*,/start_day = $start_day,/g" namelist.input
sed -i "s/start_hour .*,/start_hour = $start_hour,/g" namelist.input
sed -i "s/end_month .*,/end_month = $end_month,/g" namelist.input
sed -i "s/end_day .*,/end_day = $end_day,/g" namelist.input
sed -i "s/end_hour .*,/end_hour = $end_hour,/g" namelist.input

# PREPARO I DATI CHEM PER IL DOMINIO 2

cd /home/colombo/WRF/CHEM/PREP-CHEM/bin
cp prep_chem_sources.inp.ETNA_1KM prep_chem_sources.inp
rm *.ctl
rm *.gra
rm *.vfm
rm ETNA*
sed -i "s/ihour=.*,/ihour=$1,/g" prep_chem_sources.inp
sed -i "s/iday=.*,/iday=$start_day,/g" prep_chem_sources.inp
sed -i "s/imon=.*,/imon=$start_month,/g" prep_chem_sources.inp
sed -i "s/iyear=.*,/iyear=$start_year,/g" prep_chem_sources.inp
sed -i "s/begin_eruption=.*,/begin_eruption='$start_year$start_month$start_day$100',/g" prep_chem_sources.inp

cp Values_1km.txt Values.txt

./prep_chem_sources_RADM_WRF_FIM_.exe
wait


mv *-g1-ab.bin /home/colombo/WRF/Build_WRF/ETNA_1KM/emissopt3_d01
mv *-g1-bb.bin /home/colombo/WRF/Build_WRF/ETNA_1KM/emissfire_d01
mv *-g1-gocartBG.bin /home/colombo/WRF/Build_WRF/ETNA_1KM/wrf_gocart_backg
mv *-g1-volc.bin /home/colombo/WRF/Build_WRF/ETNA_1KM/volc_d01
rm *.gra
rm *.ctl
rm *.vfm
rm ETNA*
cd $DIRECTORY_ETNA_1KM

#RIMUOVO I MET_EM.D01 E RINOMINO I MET_EM.D02 MET_EM.D01
cp met_em* $DIRECTORY_ETNA_1KM/MET_EM_BK/
rm met_em.d01*
ls met_em* | rename 's/d02/d01/g'


./convert_emiss.exe

sed -i "s/chem_opt .*,/chem_opt = 400,/g" namelist.input


./real.exe
wait

mpirun -np 24 ./wrf.exe
wait

cd $SCRIPTS
./runNCL_ETNA.sh $1
exit

