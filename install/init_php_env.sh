#!/bin/sh
#------------------------------------------------
#      Centos7 Project Svn Updater Script
#      copyright https://echat.oshit.com/
#      email: meyer_net@foxmail.com
#------------------------------------------------
for TMP_FOLDER in $(ls)
do
    if [ -d "$TMP_FOLDER" ]; then
        cd $TMP_FOLDER
        echo "init project - $TMP_FOLDER"
        composer clear
        composer update
        php artisan config:cache
        cd ..
    fi
done