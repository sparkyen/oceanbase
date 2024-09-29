#!/bin/bash

# 命令1 和 命令2 将并行执行
bash perf_excute.sh &
bash perf_monitor.sh &

# 等待所有后台任务完成
wait

echo "Both commands have finished."

bash perf_visual.sh


