#!/bin/bash
# Author: Grigruss <grigruss@ya.ru>
# Git: https://git.tuxnix.ru/nixscript/watch-srv
# Group VK: https://vk.com/nixscript
#
# Uncomment and edit last line of this script
# Раскомментируйте и исправтье последнюю строку

function check(){
	srv=$(ssh -p $3 "$1@$2" w -h 2>/dev/null)
	if (($?>0)); then
		termux-notification --title "Нет доступа к $2" --id 10 --button1 "Закрыть" --button1-action "termux-notification-remove 10" --priority high --led-on 800 --led-color FF0000 --content "Проверьте подключение интернет."
	elif [ ! -z "$srv" ]; then
		if (($(cat /data/data/com.termux/files/usr/var/log/srvlgn.log)==1)); then exit; fi
		termux-notification \
			--title "Залогинились на $2" \
			--id 10 \
			--button1 "Свои" \
			--button1-action "echo '1'>/data/data/com.termux/files/usr/var/log/srvlgn.log; termux-notification-remove 10; cat /data/data/com.termux/files/usr/var/log/srvlgn.log" \
			--button2 "Скопировать" \
			--button2-action "termux-clipboard-set '$srv'; termux-notification-remove 10" \
			--button3 "Получить весь лог" \
			--button3-action "ssh -p $3 $1@$2 last >/data/data/com.termux/files/home/storage/downloads/server-login.log; termux-notification --id 10 --priority high --content 'Лог загружен в Downloads/server-login.log' --button1 'Закрыть' --button1-action 'termux-notification-remove 10'" \
			--content "$srv" \
			--priority high \
			--led-on 800 \
			--led-color FF0000
	else
		echo >/data/data/com.termux/files/usr/var/log/srvlgn.log
	fi
}

# Uncomment last line and change parameters after the word "check"
# Раскомментируйте следующую строку и замените значения после слова "check"
#check "login" "server.ru" 22
