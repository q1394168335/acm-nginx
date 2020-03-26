#!/bin/bash
CONFIG="user nginx;
worker_processes auto;

worker_rlimit_nofile 65536;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections 4096;
    multi_accept on;
    use epoll;
}
stream {upstream local-proxy {"
for (( i=0; i>-1; i++ ))
do
	upstream=`eval echo '$'"UPSTREAM_${i}"`
	if [ -z ${upstream} ];then
		break
	fi
	CONFIG=${CONFIG}"server "${upstream}";"
done

CONFIG=${CONFIG}"}server{listen 1080;proxy_pass local-proxy;}}"
echo ${CONFIG}> /etc/nginx/nginx.conf
exec nginx -g 'daemon off;'
