#1  oceanbase::sql::ObSelectLogPlan::generate_normal_raw_plan (this=0x7f618cc1ce00)
    at ./src/sql/optimizer/ob_select_log_plan.cpp:4240
#2  0x00007f62ad2d4c43 in oceanbase::sql::ObLogPlan::generate_raw_plan (
    this=this@entry=0x7f618cc1ce00) at ./src/sql/optimizer/ob_log_plan.cpp:11742
#3  0x00007f62ad3517f5 in oceanbase::sql::ObLogPlan::generate_plan (this=0x7f618cc1ce00)
    at ./src/sql/optimizer/ob_log_plan.cpp:11700
#4  0x00007f62ad47504f in oceanbase::sql::ObOptimizer::optimize (this=0x7f61af44b028, stmt=...,
    logical_plan=@0x7f61af44b098: 0x0) 
    at ./src/sql/optimizer/ob_optimizer.cpp:63
#5  0x00007f62b028613d in oceanbase::sql::ObSql::optimize_stmt (optimizer=..., session_info=...,
    stmt=..., logical_plan=@0x7f61af44b098: 0x0) 
    at ./src/sql/ob_sql.cpp:3731
#6  0x00007f62b028017f in oceanbase::sql::ObSql::generate_plan (
    this=this@entry=0x7f62ba0e2480 <oceanbase::observer::ObServer::get_instance()::THE_ONE+1219072>, parse_result=..., pc_ctx=pc_ctx@entry=0x7f61af44b5a0, sql_ctx=..., result=...,
    mode=<optimized out>, mode@entry=oceanbase::sql::PC_TEXT_MODE, basic_stmt=0x7f618cc07c20,
    stmt_need_privs=..., stmt_ora_need_privs=...) 
    at ./src/sql/ob_sql.cpp:3365    
    result=..., mode=<optimized out>,
    mode@entry=oceanbase::sql::PC_TEXT_MODE, basic_stmt=
    0x7f618cc07c20, stmt_need_privs=...,
    stmt_ora_need_privs=...) 
    at ./src/sql/ob_sql.cpp:3365
#7  0x00007f62b0279c1b in oceanbase::sql::ObSql::generate_physical_plan (
    this=this@entry=0x7f62ba0e2480 <oceanbase::observer::ObServer::get_instance()::THE_ONE+1219072>, parse_result=...,
    pc_ctx=pc_ctx@entry=0x7f61af44b5a0, sql_ctx=...,
    result=..., is_begin_commit_stmt=false,
    mode=oceanbase::sql::PC_TEXT_MODE,
    outline_parse_result=0x7f61af44b250)
    at ./src/sql/ob_sql.cpp:3148
#8  0x00007f62b0270358 in oceanbase::sql::ObSql::handle_physical_plan (
    this=this@entry=0x7f62ba0e2480 <oceanbase::observer::ObServer::get_instance()::THE_ONE+1219072>, trimed_stmt=...,
    context=..., result=..., pc_ctx=..., get_plan_err=-5138)
    at ./src/sql/ob_sql.cpp:5032
#9  0x00007f62b02577db in oceanbase::sql::ObSql::handle_text_query (
    this=0x7f62ba0e2480 <oceanbase::observer::ObServer::get_instance()::THE_ONE+1219072>, stmt=..., context=..., result=...)
    at ./src/sql/ob_sql.cpp:2689
#10 oceanbase::sql::ObSql::stmt_query (
    this=0x7f62ba0e2480 <oceanbase::observer::ObServer::get_instance()::THE_ONE+1219072>, stmt=..., context=..., result=...)
    at ./src/sql/ob_sql.cpp:222
#11 0x00007f62ac867000 in oceanbase::observer::ObMPQuery::do_process (this=0x7f61af45d640, session=...,
    has_more_result=false, force_sync_resp=false,
--Type <RET> for more, q to quit, c to continue without paging--
     out>) at ./src/observer/mysql/obmp_query.cpp:760
#12 oceanbase::observer::ObMPQuery::process_single_stmt (this=<optimized out>,
    this@entry=0x7f61af45d640, multi_stmt_item=..., conn=<optimized out>, session=...,
    has_more_result=false, force_sync_resp=false, async_resp_used=@0x7f61af451121: false,
    need_disconnect=@0x7f61af451123: true) at ./src/observer/mysql/obmp_query.cpp:524
#13 0x00007f62ac863a95 in oceanbase::observer::ObMPQuery::process (this=<optimized out>)
    at ./src/observer/mysql/obmp_query.cpp:326
#14 0x00007f62b71bda5a in oceanbase::rpc::frame::ObSqlProcessor::run (this=0x7f61af45d640)
    at ./deps/oblib/src/rpc/frame/ob_sql_processor.cpp:41
#15 0x00007f62ac765eef in oceanbase::omt::ObWorkerProcessor::process_one (
    this=this@entry=0x7f61b63fb848, req=...) at ./src/observer/omt/ob_worker_processor.cpp:88
#16 0x00007f62ac765172 in oceanbase::omt::ObWorkerProcessor::process (this=<optimized out>,
    this@entry=0x7f61b63fb848, req=...) at ./src/observer/omt/ob_worker_processor.cpp:156
#17 0x00007f62ac764418 in oceanbase::omt::ObThWorker::process_request (
    this=this@entry=0x7f61b63fb780, req=...) at ./src/observer/omt/ob_th_worker.cpp:244
#18 0x00007f62ac76393e in oceanbase::omt::ObThWorker::worker (this=0x7f61b63fb780,
    tenant_id=@0x7f61af451d58: 1004, req_recv_timestamp=@0x7f61af451d60: 1716546668406736,
    worker_level=@0x7f61af451d6c: 0) at ./src/observer/omt/ob_th_worker.cpp:386
#19 0x00007f62ac764964 in non-virtual thunk to oceanbase::omt::ObThWorker::run(long) ()
    at ./src/observer/omt/ob_th_worker.cpp:423
#20 0x00007f62b6776722 in oceanbase::lib::Thread::run (this=0x7f61b63fbab0)
    at ./deps/oblib/src/lib/thread/thread.cpp:172
#21 oceanbase::lib::Thread::__th_start (arg=<optimized out>)
    at ./deps/oblib/src/lib/thread/thread.cpp:341
#22 0x00007f62a185be25 in start_thread () from /lib64/libpthread.so.0
#23 0x00007f62a1583f1d in clone () from /lib64/libc.so.65月24日 18:31#0  oceanbase::sql::ObSelectLogPlan::generate_raw_plan_for_plain_select (this=0x7f618cc1ce00)
    at ./src/sql/optimizer/ob_select_log_plan.cpp:4359
