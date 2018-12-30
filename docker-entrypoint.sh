#!/bin/bash

## config param
endpoint=$ENDPOINT
namespace=$NAMESPACE 
accessKey=$ACCESS_KEY 
secretKey=$SECRET_KEY 
dataId=$DATA_ID
group=$GROUP
## config param end

## get serverIp from address server
serverIp=`curl $endpoint:8080/diamond-server/diamond -s | awk '{a[NR]=$0}END{srand();i=int(rand()*NR+1);print a[i]}'`

## config sign
timestamp=`echo $[$(date +%s%N)/1000000]`
signStr=$namespace+$group+$timestamp
signContent=`echo -n $signStr | openssl dgst -hmac $secretKey -sha1 -binary | base64`

## request
TEXT=$(curl -s -H "Spas-AccessKey:"$accessKey -H "timeStamp:"$timestamp -H "Spas-Signature:"$signContent "http://"$serverIp":8080/diamond-server/config.co?dataId="$dataId"&group="$group"&tenant="$namespace)
echo $TEXT > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'