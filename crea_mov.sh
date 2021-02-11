cd /home/colombo/WRF/Build_WRF/script_NCL/dust
rm *.000001.png
ls Ash_ETNA* | rename 's/.000002.png/.png/g' 

a=1
while [ $a -le 48 ]
do
convert -trim Ash_ETNA_3km$a.png Ash_ETNA_3km$a.png
a=$(( $a + 1 ))
done

x=1
while [ $x -le 9 ] 
do
mv Ash_ETNA_3km$x.png Ash_ETNA_3km0$x.png
x=$(( $x + 1 ))
done

convert -delay 60 Ash_ETNA*.png ASH_ETNA_3KM.gif
