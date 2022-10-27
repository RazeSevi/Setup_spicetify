#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m'

result=""

handler() {
	clear
	exit 0
}

trap handler SIGINT


printer() {
	echo $@ | cut -d ' ' -f1
}

draw_position() {
	location="$1"
	value="$2"
	tput cup "$location" "0"
	tput el
	echo -e "${NC}$value"
	tput cup "$location" "0"
}

menu() {
	local selection="1"
	local length="0"

	clear
	echo "$1"
	echo "----------------------------------------------------"
	local i="0"
	IFS=","
	for item in ${@:2}; do
		i=$((i + 1))
		if [[ "$i" == "$selection" ]]; then
			echo -e "> ${PURPLE}$(printer $item)${NC}"
		else
			echo -e "$(printer $item)"
		fi
	done
	length="$i"

	while true; do
		res=$(read_char)

		i="0"
		for val in ${@:2}; do
			i=$((i + 1))
			if [[ "$i" == "$selection" ]]; then
				item="$val"
			fi
		done

		case "$res" in
			'UP')
				draw_position "$(( selection + 1 ))" "$(printer $item)"
				selection="$((selection - 1))"
				if [[ "$selection" -lt "1" ]]; then
					selection="1"
				fi
				i="0"
				for val in ${@:2}; do
					i=$((i + 1))
					if [[ "$i" == "$selection" ]]; then
						item="$val"
					fi
				done

				draw_position "$(( selection + 1 ))" "> ${PURPLE}$(printer $item)${NC}"

				;;
			'DN')
				draw_position "$(( selection + 1 ))" "$(printer $item)"
				selection="$((selection + 1))"
				if [[ "$selection" -gt "$length" ]]; then
					selection="$length"
				fi

				i="0"
				for val in ${@:2}; do
					i=$((i + 1))
					if [[ "$i" == "$selection" ]]; then
						item="$val"
					fi
				done

				draw_position "$(( selection + 1 ))" "> ${PURPLE}$(printer $item)${NC}"
				;;
			'ENT')
				break
				;;
		esac
	done

	i="0"
	IFS=","
	for line in ${@:2}; do
		i=$((i + 1))
		if [[ "$i" == "$selection" ]]; then
			result=$line	
		fi
	done
}

read_char() {
	while true; do
		escape_char=$(printf "\u1b")
		read -rsn1 mode # get 1 character
		if [[ $mode == $escape_char ]]; then
			read -rsn2 mode # read 2 more chars
		fi
		case $mode in
		#'q') echo QUITTING ; exit ;;
		'[A')
			echo UP
			return
			;;
		'[B')
			echo DN
			return
			;;
		'')
			echo ENT
			return
			;;
		#'[D') echo LEFT ;;
		#'[C') echo RIGHT ;;
		*) >&2 ;;
		esac
	done
}


list_themes() {
	find "$HOME/install_spicetify/spicetify-themes" -maxdepth 2 -type f -iname '*.png' -exec sh -c 'echo $(basename {} .png) $(basename $(dirname {}))' \; | sort | uniq 
}

set_theme() {

	IFS=","
	menu "Enter the theme you want: " $(list_themes | tr '\n' ',')
	clear
			
	scheme=$(echo $result | cut -d' ' -f1)			
	theme=$(echo $result | cut -d' ' -f2)			

	spicetify config color_scheme $scheme
	spicetify config current_theme $theme
	spicetify apply
}


set_default() {
	clear
	echo "Setting theme to default"
	spicetify restore
	echo "Done"
}

set_info() {
	clear
	echo "Theme changes the color theme, how your spotify wil look."
	echo "Default sets the theme to it's original look"
	read -p "Press enter to continue"

}

while true; do
menu "Select an option:" "Theme" "Info" "Default"
case "$result" in
	"Theme")
		set_theme
		break;
	;;
	"Info")
		set_info
	;;
	"Default")
		set_default
		break;
	;;
esac
done
