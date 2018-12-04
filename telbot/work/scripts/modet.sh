#!/system/bin/sh
cmd="$1"
if [ ${#cmd} -lt 2 ]; then
echo "modet:on|off"
exit
fi
if [ $cmd = "on" ];then
    curl http://127.0.0.1:8080/settings/motion_detect?set=on
    exit
fi
if [ $cmd = "off" ];then
    curl http://127.0.0.1:8080/settings/motion_detect?set=off
    exit
fi
echo "unknown option"
