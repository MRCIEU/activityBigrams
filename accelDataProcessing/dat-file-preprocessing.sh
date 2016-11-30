



for f in ../data/F11_activity_renamed/*.*
do
	fname=$(basename $f)
	fbname=${fname%.*}
#	echo $fbname
	tail -n +11 $f | sed -E "s/[[:space:]]+/,/g" | sed 's/,$//g' | sed 's/^,//g' > ../data/F11-processed/${fbname}.csv
done
