#!/bin/sh
CONFIG="upstream local-proxy {\n"
for (( i=0; i>-1; i++ ))
do
	upstream=`eval echo '$'"UPSTREAM_${i}"`
	if [ -z ${upstream} ];then
		break
	fi
	CONFIG=${CONFIG}"\tserver "${upstream}";\n"
done

CONFIG=${CONFIG}"}\nserver{\n\tlisten 1080;\n\tproxy_pass local-proxy;\n}"
echo ${CONFIG}> /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
