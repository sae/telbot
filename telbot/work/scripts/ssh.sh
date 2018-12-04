#!/system/bin/sh
cmd="$1"
if [ ${#cmd} -lt 3 ]; then
echo "ssh:<host/port> | ssh:log"
echo "user: sshtunnel, key:"
cat /data/1sae/.ssh/sae.pub
exit
fi
if [ $cmd = "log" ];then
    cat /data/1sae/ssh.log
    exit
fi
host="$cmd"
/data/1sae/dropbear/ssh -v -N -y -i /data/1sae/.ssh/sae \
 -K 20 -R *:6022:127.0.0.1:22 -R *:6080:127.0.0.1:8080 sshtunnel@$host >/data/1sae/ssh.log 2>&1 &
echo "ssh to $host started, see log. ports 6022 and 6080"
