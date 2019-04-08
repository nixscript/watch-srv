#!/bin/bash
# Author: Grigruss <grigruss@ya.ru>
# Git: https://git.tuxnix.ru/nixscript/watch-srv
# Group VK: https://vk.com/nixscript
#
# Uncomment and edit last line of this script

function check(){
	if ! srv=$(ssh -p "$3" "$1@$2" w -h 2>/dev/null)
	then
		termux-notification \
			--title "No access to $2" \
			--id "$4" \
			--button1 "Close" \
			--button1-action "termux-notification-remove $4" \
			--priority high \
			--led-on 800 \
			--led-color FF0000 \
			--content "Check internet connection."
	elif [ -n "$srv" ]; then
		F=$(cat "/data/data/com.termux/files/usr/var/log/srvlgn$4.log")
		if [ -n "$F" ]; then exit; fi
		termux-notification \
			--title "Logged in to the $2" \
			--id "$4" \
			--button1 "All right" \
			--button1-action "termux-notification-remove $4
				echo 1 >/data/data/com.termux/files/usr/var/log/srvlgn$4.log" \
			--button2 "Copy" \
			--button2-action "termux-notification-remove $4
				termux-clipboard-set \"$srv\"" \
			--button3 "Get full log" \
			--button3-action "ssh -p $3 $1@$2 last >/data/data/com.termux/files/home/storage/downloads/server-login.log
				termux-notification \
					--id $4 \
					--priority high \
					--content \"Log loaded to Downloads/server-login.log\" \
					--button1 \"Close\" \
					--button1-action \"termux-notification-remove $4\"" \
			--content "$srv" \
			--priority high \
			--led-on 800 \
			--led-color FF0000 \
			--sound
	else
		echo >"/data/data/com.termux/files/usr/var/log/srvlgn$4.log"
	fi
}

# Uncomment last line and change parameters after the word "check"
# If you use a script to monitor multiple servers, the notification-id
# should be unique for each server.
#      login   host/ip  port  notification-id
#check "login" "server.ru" 22 0
#check "login1" "server1.ru" 22 1
