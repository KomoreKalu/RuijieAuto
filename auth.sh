#!/bin/bash
USERID=###
PWD=###
UA="Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/86.0.4240.114 Mobile Safari/537.36"
Index=###

CAPTIVECODE=$(curl -s -o /dev/null -w "%{http_code}" http://www.gstatic.com/generate_204)

login(){
	curl -s -A "$UA" -d "userId=$USERID&password=$PWD&service=&queryString=&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" "http://172.30.1.111:8080/eportal/InterFace.do?method=login"
}


logout(){
	curl -s -A "$UA" -d "$Index" "http://172.30.1.1/eportal/InterFace.do?method=logout"
}

$1
