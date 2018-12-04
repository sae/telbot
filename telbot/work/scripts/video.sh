#!/system/bin/sh
DIR=/sdcard/ipwebcam_videos

cmd="$1"
if [ ${#cmd} -lt 2 ]; then
echo "video:<filename>|clear"
exit
fi

if [ $cmd = "clear" ];then
    rm $DIR/old/
    rm $DIR/.thumbs/old/
    echo "cleared"
    exit
fi

file="$1"
if [ ! -e $DIR/old/"$file" ]; then
    echo "file $file not exist"
exit
fi
/data/1sae/tel-video.sh $DIR/old/"$file" >/dev/null

echo "video sent" 
