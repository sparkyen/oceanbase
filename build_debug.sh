source /usr/local/obdev/setup.sh
# sudo rm -r build_debug
# sh build.sh --init
# cd cmake-build-debug
cd build_debug
# sh build.sh --init release
# cd build_release
# # 使用ob-make进行编译 
# #（若机器上没有ob-make 可以使用 make -jN进行编译，N=空余内存G/2G，如果OOM了，尝试再减小）
ob-make
# read -p "enter cluster name: " cluster_name
# ob do reinstall --cp -n $cluster_name
ob do reinstall --cp -n ob2