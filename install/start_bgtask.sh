#!/bin/bash
function exec_request()
{
	for i in {1..60}
	do
		output_time=$(date '+%Y-%m-%d %H:%M:%S')
		response_data=$(curl -l http://server:ip/$uri)
		echo "$i"": ""$output_time"" => ""$response_data" >> /clouddisk/svr_sync/wwwroot/prj/www/or/lor-project/logs/cron_lor_project.log
		/bin/sleep 1
	done

	return $?
}

exec_request

exit 0