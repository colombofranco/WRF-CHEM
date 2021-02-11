
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

#ATTIVO LA CHEM E FACCIO NDOWN
sed -i "s/io_form_auxinput2 .*,/io_form_auxinput2 = 2,/g" namelist.input
sed -i "s/io_form_auxinput13 .*,/io_form_auxinput13 = 2,/g" namelist.input
sed -i "s/chem_opt .*,/chem_opt = 401, 401,/g" namelist.input
sed -i "s/emiss_opt_vol .*,/emiss_opt_vol = 1, 1,/g" namelist.input

#SPENGO LA CHEM E FACCIO NDOWN

#sed -i "s/io_form_auxinput2 .*,/io_form_auxinput2 = 2,/g" namelist.input
#sed -i "s/io_form_auxinput13 .*,/io_form_auxinput13 = 0,/g" namelist.input
#sed -i "s/chem_opt .*,/chem_opt = 0, 0,/g" namelist.input
#sed -i "s/emiss_opt_vol .*,/emiss_opt_vol = 1, 1,/g" namelist.input



#LINK DEL WRFOUT DEL DOMINIO 1

ln -sf /home/colombo/DATI/WRFOUT/wrfout_ETNA3km_"$start_date" wrfout_d01_"$start_date"

mv wrfinput_d02 wrfndi_d02


mpirun -np 12 ./ndown.exe

rm wrfout_d01*
mv wrfinput_d02 wrfinput_d01
mv wrfbdy_d02 wrfbdy_d01

#mpirun -np 24 ./wrf.exe
#wait
cd $SCRIPTS
./convert_1km.sh $1

exit

#lancio lo script per il dominio 2

#cd $SCRIPTS
#./build_em_nest.sh 00
