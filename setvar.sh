source /home/colombo/WRF/Build_WRF/ambiente.sh
export LD_LIBRARY_PATH=/home/colombo/WRF/Build_WRF/LIBRARIES/grib2/lib
MAIN_DIRECTORY=/home/colombo/WRF/Build_WRF
ARCHIVE_WRFOUT=/home/colombo/DATI/WRFOUT
ARCHIVE_IMAGES=/home/colombo/DATI/IMAGES
ARCHIVE_UPPOUT=/home/colombo/DATI/UPPOUT
SCRIPTS=/home/colombo/WRF/Build_WRF/SCRIPT_CHEM
RECOVERY=/home/colombo/WRF/SCRIPT/RECOVERY
LOGS=/home/colombo/WRF/LOGS
WPS=../WPS-4.1
GRIBS=/home/colombo/DATI/GRIBS
NCL=/home/colombo/WRF/Build_WRF/script_NCL
UPP=/home/colombo/WRF/Build_WRF/UPPV4.0/postprd
GRADS=/home/colombo/WRF/Build_WRF/grads
PHP_DIRECTORY=/home/colombo/PHP

runWPS_9km=ON
runWPS_3km=ON
runWPS_1km=ON
logwrf_3KM=/home/colombo/WRF/LOGS/3KM.txt
logwrf_9KM=/home/colombo/WRF/LOGS/9KM.txt
logwrf_1KM=/home/colombo/WRF/LOGS/1KM.txt

DIRECTORY_9KM=/home/colombo/WRF/Build_WRF/ETNA_9KM
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

