observer_pid=$(pgrep observer)
sudo perf record -e cycles -c 100000000 -p "$observer_pid" -g -- sleep 20
sudo perf script -F ip,sym -f > data.viz