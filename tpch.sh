source /usr/local/obdev/setup.sh
activate-obd
ob do create_tenant
export REMOTE_TBL_DIR="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen/tpch1"
export TBL_PATH="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen/tpch1"
export DBGEN_BIN="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen/dbgen"
export DSS_CONFIG="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen"
export DDL_PATH="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen/tpch1/create_table.ddl"
export SQL_PATH="/home/xiaoyen.xy/prj/ob/test/tpch/dbgen/queries/test"
export TMP_DIR="/obdata/tmp"
ob do tpch \
--remote-tbl-dir=$REMOTE_TBL_DIR \
--dbgen-bin=$DBGEN_BIN \
--dss-config=$DSS_CONFIG \
--ddl-path=$DDL_PATH \
--tbl-path=$TBL_PATH \
--sql-path=$SQL_PATH \
--tmp-dir=TMP_DIR \
-s 1 -O 0 --dt -v
