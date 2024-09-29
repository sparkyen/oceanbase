#!/bin/bash

# 数据库连接信息
DB_HOST="127.0.0.1"
DB_USER="root"
DB_PORT="39602"
DB_NAME="test"
SQL_STATEMENT="SELECT * FROM t1
WHERE  c1 in (SELECT c1 FROM t2 WHERE  t2.c2 = t1.c2)
AND c1 in (SELECT c1 FROM t2 WHERE t2.c2 = t1.c2 AND t2.c3 > 1); "  # 替换为你的SQL查询语句
SQL_FILE="perf.sql"

# obclient -h"$DB_HOST" -u"$DB_USER" -P"$DB_PORT" -D"$DB_NAME" -e "$SQL_STATEMENT"

# 获取当前时间（开始时间）
START_TIME=$(date +%s)

# 计算结束时间，2分钟后
END_TIME=$((START_TIME + 25))

# 重复执行SQL语句直到达到结束时间
while [ $(date +%s) -lt $END_TIME ]; do
    # obclient -h"$DB_HOST" -u"$DB_USER" -P"$DB_PORT" -D"$DB_NAME" -e "$SQL_STATEMENT"
    obclient -h"$DB_HOST" -u"$DB_USER" -P"$DB_PORT" -D"$DB_NAME" < "$SQL_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Successfully executed at $(date)"
    else
        echo "Failed to execute at $(date)"
    fi
    sleep 1  # 每次执行后等待1秒
done