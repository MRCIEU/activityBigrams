



for f in ../../data/original/F11_activity_renamed/*.*
do
	fname=$(basename $f)
	fbname=${fname%.*}
#	echo $fbname
	tail -n +11 $f | sed -E "s/[[:space:]]+/,/g" | sed 's/,$//g' | sed 's/^,//g' > ../../data/derived/accel/F11-processed/${fbname}.csv
done
