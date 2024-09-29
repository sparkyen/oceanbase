HISTFILE=~/.tmp_history
HISTSIZE=1000
HISTFILESIZE=2000

if [ ! -f "$HISTFILE" ]; then
  touch "$HISTFILE"
fi

history -r
set -o vi
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

hostname="127.0.0.1"
port="39602"
username="root"
dbname="test"
while true
do 
    
    read -ep  ">> " op
    if [[ $op == !* ]]; then
        op="${op:1}"
        if [ "$op" = "exit" ]; then
            break
        elif [ "$op" = "trace" ]; then
            # trace_info=$(obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"select last_trace_id() from dual;")        
            cd /obdata/data/2/log
            vim <(grep "$trace_id" observer.log)
        elif [ "$op" = "init" ]; then
            obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"set ob_enable_show_trace=true;set ob_log_level='debug';"
        fi
    else
        sql="${op}"
        obclient_cmd="obclient -h${hostname} -P${port} -u${username} -D${dbname} -e\"${sql}; select last_trace_id() from dual;\" --force" 
        # sql_file=$(mktemp /tmp/commands.XXXXXX.sql)
        # echo "$sql" >> "$sql_file"
        # echo "select last_trace_id() from dual;" >> "$sql_file"
        # cat $sql_file
        # obclient_cmd="obclient -h${hostname} -P${port} -u${username} -D${dbname} -e --force "$sql_file""
        temp_file=$(mktemp)
        script -q -c "$obclient_cmd" $temp_file >/dev/null 2>&1
        awk '
        NR==1 {next}
        !skip && /last_trace_id/ {skip=1; next}
        !skip {if (prev) print prev; prev=$0}
        ' $temp_file
        cat $temp_file
        trace_id=$(grep -oP "[A-Z0-9]{13}-[A-Z0-9]{16}-\d-\d" $temp_file)
        # echo $trace_id
        rm "$temp_file"
        # rm "$sql_file"
    fi
done
# EOF

    # read -ep ">> use trace_id filter? (y/n) " USER_CHOICE
    # log_file="observer.log"
    # temp_file=$(mktemp)
    # grep "$trace_id" "$log_file" > "$temp_file"

    # if [ -s "$temp_file" ]; then
    #     vim "$temp_file"
    # else
    #     echo "No matches found for $search_pattern in $log_file."
    # fi
    # rm "$temp_file"

    # while read line;
    # do 
    #     echo $line
    # done < tmp.txt
    # rm tmp.txt

    # rm $tmp_file
    # cat $temp_file
    # eval $obclient_cmd | tee $tmp_file
    # trace_id=$(grep -oP "last_trace_id\(\) \K\w+-\w+-\w+-\w+" $tmp_file)
    
    # echo "Extracted trace_id: $trace_id"


    # obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"$op select last_trace_id() from dual;" | tee $temp_file
    # excution_log=$(obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"$op select last_trace_id() from dual;")
    # { read -r output; echo "$output"; } < <($excution_log)
    # trace_id=$(echo $excution_log | grep -oP "last_trace_id\(\) \K\w+-\w+-\w+-\w+")
    # echo $trace_id
    # echo $excution_log

    # obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"$op select last_trace_id() from dual;"
    # echo $_
    # obclient -h127.0.0.1 -P39602 -uroot -Dtest -e"$op"
    # obclient_cmd="obclient -h${hostname} -P${port} -u${username} -D${dbname} -e\"$sql
    #                                                                             select last_trace_id() from dual;\""
