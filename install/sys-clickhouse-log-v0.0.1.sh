
#!/bin/bash
THIS_TIME=`date +%Y-%m-%d,%H:%m:%s`
echo -ne "'------------------------------------\nscript edit time: '2018-06-05 15:00:00'\ninit ${project_name}_log clickhouse db at: '$THIS_TIME'\n------------------------------------\n"

function exec_sql()
{
    local TMP_SQL=$1
    local TMP_DATABASE=$2
    if [ ! -n "$TMP_DATABASE" ]; then
        TMP_DATABASE="default"
    fi

    cat <<_EOF | clickhouse-client --host=$db_host --port=$db_port --user=default --password=$db_upwd --database=$TMP_DATABASE;
    ${TMP_SQL}
_EOF
    return $?
}

exec_sql "CREATE DATABASE IF NOT EXISTS ${project_name}_log"
exec_sql "
CREATE TABLE IF NOT EXISTS sys_logs
(
    id String,
    uri String,
    host String,
    level INT,
    content String,
    \`from\` String,
    project String,
    create_date DATE,
    create_time DATETIME DEFAULT now()
) ENGINE = MergeTree(create_date, intHash32(level), (id, uri, project, \`from\`, intHash32(level)), 8192)
" "${project_name}_log"