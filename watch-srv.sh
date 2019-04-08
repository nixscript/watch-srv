#!/bin/bash
# Author: Grigruss <grigruss@ya.ru>
# Git: https://git.tuxnix.ru/nixscript/watch-srv
# Group VK: https://vk.com/nixscript
#
# Раскомментируйте последнюю строку и замените параметры на свои.

function check(){
	if ! srv=$(ssh -p "$3" "$1@$2" w -h 2>/dev/null)
	then
		termux-notification \
			--title "Нет доступа к $2" \
			--id "$4" \
			--button1 "Закрыть" \
			--button1-action "termux-notification-remove $4" \
			--priority high \
			--led-on 800 \
			--led-color FF0000 \
			--content "Проверьте подключение интернет."
	elif [ -n "$srv" ]; then
		F=$(cat "/data/data/com.termux/files/usr/var/log/srvlgn$4.log")
		if [ -n "$F" ]; then exit; fi
		termux-notification \
			--title "Залогинились на \"$2\"" \
			--id "$4" \
			--button1 "Свои" \
			--button1-action "termux-notification-remove $4
				echo 1 >/data/data/com.termux/files/usr/var/log/srvlgn$4.log" \
			--button2 "Скопировать" \
			--button2-action "termux-notification-remove $4
				termux-clipboard-set \"$srv\"" \
			--button3 "Получить весь лог" \
			--button3-action "ssh -p $3 $1@$2 last >/data/data/com.termux/files/home/storage/downloads/server-login.log
				termux-notification \
					--id $4 \
					--priority high \
					--content \"Лог загружен в Downloads/server-login.log\" \
					--button1 \"Закрыть\" \
					--button1-action \"termux-notification-remove $4\"" \
			--content "$srv" \
			--priority high \
			--sound
	else
		echo >"/data/data/com.termux/files/usr/var/log/srvlgn$4.log"
	fi
}

# Раскомментируйте последнюю строку, укажите свои параметры после  слова "check"
# Если вы используете скрипт для мониторинга нескольких серверов, указывайте
# уникальный "notification-id" для каждого сервера.
#      login   host/ip  port  notification-id
#check "login" "server.ru" 22 0
#check "login1" "server1.ru" 22 1
