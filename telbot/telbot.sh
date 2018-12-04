#!/system/bin/sh

#bot command prefix
#command syntax: <prefix>:<command>:<params
prefix="n1"
#commans dir
workdir="/data/1sae/telbot/work"
#bot token
token=
#polling timeout (see api)
timeout=60
#sleep time  in sec
#sleeptime=10
PATH=/data/1sae/bin:$PATH:/system/xbin
curl="/system/xbin/curl"
curlp="-k"
#"--cacert /data/1sae/tls-ca-bundle.pem"
busybox="/system/xbin/busybox1"
cmd=""

while [ true ]; do

#update "offset", see api doc
offset=`cat $workdir/offset`
if [ ${#offset} -lt 2 ]; then
offset="0"
fi
#echo offset=$offset

#need this sleep when curl returns error
if [ ${#cmd} -lt 3 ]; then
echo "sleeping..."
sleep 10
fi
echo polling...
updates=`"$curl" "$curlp" --connect-timeout 30 -X POST "https://api.telegram.org/bot$token/getUpdates" -F offset=$offset -F limit=1 -F timeout=$timeout`
#-F chat_id=$chat_id - if you need to receive commands from part.chat
echo "$updates" >$workdir/updates
echo update:"$updates"

offset=`cat "$workdir"/updates | $busybox grep -Eo 'update_id":([0-9])*' | $busybox grep -Eo '([0-9])*' | tail -1`
#replace only if valid offset found
echo offlen=${#offset} 
if [ ${#offset} -gt 5 ]; then
offset=$((offset+1))
echo "$offset" >$workdir/offset
fi
echo new_offset="$offset"

chat_id=`cat "$workdir"/updates | $busybox grep -Eo '"chat":{"id":([-0-9])*' | $busybox grep -Eo '([-0-9])*' | tail -1`
echo chat:"$chat_id"

regexp="$prefix:([^\"])*"
cmd=`cat "$workdir"/updates | $busybox grep -Eo "$regexp" `
if [ ${#cmd} -lt 3 ]; then
    echo "no commands"
    #sleeping if no commands
    #echo sleeping...
    #sleep $sleeptime
    continue
fi

IFS=':'
set -- $cmd
echo cmd:"$2"
if [ -f "$workdir/scripts/$2.sh" ]; then

export TOKEN=$token
export CHAT_ID=$chat_id
export WORKDIR=$workdir
resp=`"$workdir"/scripts/$2.sh $3`
# 2>&1`
# >>log 2>&1 &
else
resp="script $2.sh not exist"
fi
echo result:
echo "$resp"

resp2=`"$curl" "$curlp"  -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id=$chat_id --data-urlencode text="$resp"`
echo "$resp2"

#sleeping after commands ?
#echo sleeping...
#sleep $sleeptime

done


