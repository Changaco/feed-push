#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

daemon_bin="/usr/bin/feed-push"
daemon_name=$(basename $daemon_bin)
pid_file="/var/run/$daemon_name.pid"
PID=$(cat $pid_file 2>/dev/null)

data_dir=/var/lib/$daemon_name
conf_dir=/etc/$daemon_name

case "$1" in
    start)
        stat_busy "Starting $daemon_name daemon"
        if [ -z "$PID" ]; then
            $daemon_bin "$conf_dir" "$data_dir/state" --fork $pid_file
            if [ $? -gt 0 ]; then
                stat_fail
                exit 1
            else
                add_daemon $daemon_name
                stat_done
            fi
        else
            stat_fail
            exit 1
        fi
        ;;

    stop)
        stat_busy "Stopping $daemon_name daemon"
        [ ! -z "$PID" ] && kill $PID &> /dev/null
        if [ $? -gt 0 ]; then
            stat_fail
            exit 1
        else
            rm -f $pid_file &> /dev/null
            rm_daemon $daemon_name
            stat_done
        fi
        ;;

    restart)
        $0 stop
        sleep 1
        $0 start
        ;;

    *)
        echo "usage: $0 {start|stop|restart}"
esac
