#!/bin/bash

if [ ! -f ./logs/nginx.pid ]; then
    echo hello
    sudo /usr/local/openresty/nginx/sbin/nginx -p `pwd`/ -c conf/nginx.conf  
fi
sudo /usr/local/openresty/nginx/sbin/nginx -p `pwd`/ -c conf/nginx.conf  -s reload

