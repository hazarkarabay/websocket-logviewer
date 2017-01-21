websocket-logviewer
=====================

`tail -f` over websockets!
A *very primitive* realtime multi-log viewer which works in your browser.

###Server side configuration
You need a websocket server to serve your tail output. [gwsocket](https://github.com/allinurl/gwsocket) works well and it has no dependencies.
After that you can pipe all your logs to your websocket server. 

For gwsocket, you can use:
`tail -f /var/log/nginx/*.log > /tmp/wspipein.fifo & gwsocket -p 7891 --pipein=/tmp/wspipein.fifo &`

or a little helper script to run in a `screen`
```bash
#!/bin/sh
trap 'kill $(jobs -p)' EXIT
tail --follow=name -n 1 "$@" > /tmp/wspipein.fifo &
gwsocket -p 7891 --pipein=/tmp/wspipein.fifo &
wait
```
**`$`**` helper.sh /var/log/nginx/*.log`

Save the HTML file on your computer and launch it with your HTML5 capable browser. Enter the server address and port in textbox like `example.com:7891` and click Connect. 

It will show last 25 lines (maximum) for each log. 

###Things to know

 - **SECURITY ALERT:** This configuration does not have any security. All your logs will happily tailed to any creature that can predict your websocket port. If you decide to use this anywhere near a production enviroment, you must implement safety measures. You can use gwsocket's `Origin` validation (not recommended, spoofable) or preferred method; bind `gwsocket` local, use `nginx` as a reverse proxy and ensure access control and upgrade WSS (websocket over TLS) in `nginx`.
 - Active logs moves to top. This can prevented by commenting out line 108.  (prepend `//` to the line)
 - If you have log rotation; your log viewing pleasure may come to halt when your logs rotated. `tail` , by default, tracks file descriptors and most `logrotate` configurations simply rename the old log (and send `SIGHUP` the log-rotated process) and create a new, empty log file. For this reason, `tail` will continue to watch your old (rotated) file. You can use `tail --follow=name` to ensure `tail` always "tails" your current log file. This workaround has been implemented in helper script.
 - If you use a wildcard like in my helper example, newly added log files does not show up your viewer. Filename expansion will occur only when you executing that command. This is expected (and obvious maybe), just reminding.

Feel free to enhance or use it for your forking pleasure.