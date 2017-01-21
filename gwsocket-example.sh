#!/bin/sh
trap 'kill $(jobs -p)' EXIT
tail --follow=name -n 1 "$@" > /tmp/wspipein.fifo &
gwsocket -p 7891 --pipein=/tmp/wspipein.fifo &
wait