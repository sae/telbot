#!/system/bin/sh

FILE=/data/photo.jpg
curl http://127.0.0.1:8080/photoaf.jpg -o $FILE

/data/1sae/tel-pict.sh $FILE >/dev/null
echo "photo sent" 
