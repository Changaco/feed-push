#!/bin/bash

die() { echo "$@"; exit 1; }

daemon_bin="/usr/bin/feed-push"
daemon_name=$(basename $daemon_bin)
pid_file="/var/run/$daemon_name.pid"
PID=$(cat $pid_file 2>/dev/null)

data_dir=/var/lib/$daemon_name
conf_dir=/etc/$daemon_name

case "$1" in
    start)
        echo "Starting $daemon_name daemon"
        if [ -z "$PID" ]; then
            $daemon_bin "$conf_dir" "$data_dir/state" --fork $pid_file
            r=$?; [ $r -gt 0 ] && die "Failure: $daemon_name returned $r"
        else
            die "Failure: $pid_file already exists"
        fi
        ;;

    stop)
        echo "Stopping $daemon_name daemon"
        [ ! -z "$PID" ] && kill $PID
        r=$?; [ $r -gt 0 ] && die "Failure: kill returned $r"
        rm -f $pid_file
        ;;

    restart)
        $0 stop
        sleep 1
        $0 start
        ;;

    *)
        echo "usage: $0 {start|stop|restart}"
esac
