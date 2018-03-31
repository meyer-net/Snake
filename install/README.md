用于定时后台执行任务。该项任务即时随系统启动

1：赋予脚本执行权限
chmod +x %APP_ROOT%/*.sh

2：编辑定时任务
crontab -e

3：添加任务对脚本定期执行
ln -sf %APP_ROOT%/logs/start_bgtask.log /var/log/start_bgtask.log
* * * * * %APP_ROOT%/install/start_bgtask.sh >> /var/log/start_bgtask.log 2>&1

例如：
	ln -sf /clouddisk/svr_sync/wwwroot/prj/www/or/lor-project/logs/start_bgtask.log /var/log/start_bgtask.log 
	* * * * * /clouddisk/svr_sync/wwwroot/prj/www/or/lor-project/install/start_bgtask.sh >> /var/log/start_bgtask.log 2>&1

4：启动任务执行脚本
service crond start（有的是service cron start）
或者
/etc/rc.d/init.d/crond start

5：加入开机自动启动
chkconfig --level 35 crond on


相关参考命令
-------------------------------------------------------------------------
crontab 文件中每个条目中各个域的意义和格式：
第一列 分钟： 1——59
第二列 小时： 1——23(0表示子夜)
第三列 日 ： 1——31
第四列 月 ： 1——12
第五列 星期： 星期0——6(0表示星期天，1表示星期一、以此类推)
第六列 要运行的命令

编辑定时任务：crontab -e
查看定时任务：crontab -l
删除当前定时任务：crontab -r

/sbin/service crond start           //启动服务
/sbin/service crond stop            //关闭服务
/sbin/service crond restart        //重启服务
/sbin/service crond reload         //重新载入配置

参考文献：http://blog.csdn.net/fdipzone/article/details/22701113
备注：运行时需要 resty.http库