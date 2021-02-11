#echo -e "\e[1;35mSetting IFORT/ICC directory variables..\e[0m"

#source /home/giovanni/intel/compilers_and_libraries_2019.5.281/linux/bin/compilervars.sh intel64

#export LD_LIBRARY_PATH=/home/giovanni/intel/compilers_and_libraries_2019.5.281/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
#ulimit -s unlimited
#export OMP_STACKSIZE=40000m
#export OMP_STACKSIZE=20000m
source /mnt/wrf-work/Build_WRF/ambiente.sh
export LD_LIBRARY_PATH=/mnt/wrf-work/Build_WRF/LIBRARIES/grib2/lib
MAIN_DIRECTORY=/mnt/wrf-work/Build_WRF
ARCHIVE_WRFOUT=/home/colombo/DATI/WRFOUT
ARCHIVE_IMAGES=/home/colombo/DATI/IMAGES
ARCHIVE_UPPOUT=/home/colombo/DATI/UPPOUT
SCRIPTS=/mnt/wrf-work/Build_WRF/SCRIPT_CHEM
RECOVERY=/home/colombo/WRF/SCRIPT/RECOVERY
LOGS=/home/colombo/WRF/LOGS
WPS=../WPS-4.1
GRIBS=/home/colombo/DATI/GRIBS
NCL=/mnt/wrf-work/Build_WRF/script_NCL
UPP=/mnt/wrf-work/Build_WRF/UPPV4.0/postprd
GRADS=/mnt/wrf-work/Build_WRF/grads
PHP_DIRECTORY=/home/colombo/PHP

runWPS_9km=ON
runWPS_3km=ON
runWPS_1km=ON
logwrf_3KM=/home/colombo/WRF/LOGS/3KM.txt
logwrf_9KM=/home/colombo/WRF/LOGS/9KM.txt
logwrf_1KM=/home/colombo/WRF/LOGS/1KM.txt

DIRECTORY_9KM=/mnt/wrf-work/Build_WRF/ETNA_9KM
DIRECTORY_2020=/home/colombo/WRF/Build_WRF/ETNA_2020
DIRECTORY_ETNA_1KM=/home/colombo/WRF/Build_WRF/ETNA_1KM

sstsource=rtg
hours9km=96
hours3km=48
hours3kmN=24
hours1kmN=48
gradshours9km=98
gradshours3km=50
gradshours1km=50
postprocessing9km_after=ON
postprocessing3km_after=ON


wrfclean=ON
postncl=OFF
cloudtype=OFF
meteogrammi=ON
skewt=OFF
uploadONLINE=ON
cleanimage=OFF

