#!/bin/bash

#PATH=/usr/local/openresty/nginx/sbin:$PATH
#export PATH

sudo /usr/local/openresty/nginx/sbin/nginx -p `pwd`/ -c conf/nginx.conf  -s reload

