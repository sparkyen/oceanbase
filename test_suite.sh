
source /usr/local/obdev/setup.sh
# join都需要统计信息才能估计准确
# ob do mysqltest -n ob2 --test-set=executor.full_join 
# ob do mysqltest -n ob2 --test-set=join.anti_semi_join
# alter system set_tp tp_no = 551, error_code = 4019, frequency = 1;
ob do mysqltest -n ob2 --test-set=skyline.skyline_business_mysql
ob do mysqltest -n ob2 --test-set=skyline.skyline_basic_mysql
ob do mysqltest -n ob2 --test-set=skyline.skyline_index_back_mysql
ob do mysqltest -n ob2 --test-set=static_engine.nested_loop_join
ob do mysqltest -n ob2 --test-set=optimizer.precise_redundant_predicate