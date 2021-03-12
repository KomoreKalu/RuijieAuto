#!/bin/bash
set -e

USERID=
PWD=
UA="Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/86.0.4240.114 Mobile Safari/537.36"
HOST=172.30.1.111:8080

queryHost(){
	curl -s "http://www.google.cn" | awk -F \' '{print $2}'  | awk -F \e '{print $1}' \
	| awk -F \/ '{print $3}'
}

queryString(){
	curl -s "http://www.google.cn" | awk -F \' '{print $2}' | awk -F \? '{print $2}' \
	| sed -e 's/=/%253D/g;s/&/%2526/g'
}

captive(){
	echo "$(curl -s -o /dev/null -w "%{http_code}" "dl.google.com/generate_204")"
}

login(){
	if [ `captive` -eq 204 ]; then
		echo "already online"
		exit
	fi	
	curl -s -X POST -H "Host:${HOST}" -H "Connection:keep-alive" -H "Content-Length:608" \
	-H "User-Agent:${UA}" -H "Content-Type:application/x-www-form-urlencoded; charset=UTF-8" \
	-H "Accept:*/*" -H "Origin:http://${HOST}" \
	-d "userId=${USERID}&password=${PWD}&service=&queryString=`queryString`&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" \
	"http://${HOST}/eportal/InterFace.do?method=login" | jq .result
}


logout(){
	if [ `captive` != 204 ]; then
		echo "already offline"
		exit
	fi
	curl -s -A "$UA"  "http://${HOST}/eportal/InterFace.do?method=logout" | jq .result
}

$1
