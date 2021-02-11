DATE=`date +%Y%m%d`

RUN=$1

sstold=24

start_date_upp=`date "-d 3 hours ago" +%Y%m%d`"$RUN"
start_date=`date "-d 3 hours ago" +%Y-%m-%d_`"$RUN:00:00"
end_date=`date "-d $hours3km hours" +%Y-%m-%d_`"$RUN:00:00"

start_year=`date +%Y`
end_year=`date "-d $hours3km hours" +%Y`
start_month=`date +%m`
end_month=`date "-d $hours3km hours" +%m`
start_day=`date "-d 3 hours ago" +%d`
end_day=`date "-d $hours3km hours" +%d`
start_hour=$RUN
end_hour=$RUN

sst_date=`date "-d $sstold hours ago" +%Y-%m-%d_`"00:00:00"
sst_date_down=`date "-d $sstold hours ago" +%Y%m%d`"00"
sst_date_down_rtg=`date "-d $sstold hours ago" +%Y%m%d`
sst_date_down_y=`date "-d $sstold hours ago" +%Y`
sst_date_down_m=`date "-d $sstold hours ago" +%m`
sst_date_constant=`date "-d $sstold hours ago" +%Y-%m-%d_`"00"
