#!/bin/bash


echo "Options:"
echo "	1) Set theme"
echo "	2) Set Scheme"
echo "	3) Set to default"
echo "	4) Info"

list_themes() {
	find "$HOME/install_spicetify/spicetify-themes" -maxdepth 2 -type f -iname '*.png' -exec basename {} .png \; | sort | uniq 
}

list_schemes() {
	find "$HOME/install_spicetify/spicetify-themes" -maxdepth 1 -type d -not  -iname '*.git*' -exec basename {} \; | sort | uniq
}

set_theme() {

			echo "Set theme"
			list_themes
			read -p "Enter the theme you want: " THEME
			clear
			spicetify config color_scheme $THEME
			spicetify apply
}

set_scheme() {
			echo "Set scheme"
			list_schemes
			read -p "Enter the scheme you want: " SCHEME
			clear
			spicetify config current_theme $SCHEME
			spicetify apply
}

while true
do
	read INPUT
	case $INPUT in
		1)
			set_theme
			break;
		;;
		2)
			set_scheme
			break;
		;;
		3)
			clear
			echo "Setting theme to default"
			spicetify restore
			echo "Done"
			break;
		;;
		4)
			clear
			echo "Theme changes the color theme, how your spotify wil look."
			echo "Scheme is where your themes are stored."
			echo "Press enter:"
		;;	
		*)
			clear
			echo "Give a valid input"
			echo "1) Set theme"
			echo "2) Set scheme"
			echo "3) Set to default"
			echo "4) Info"
		;;
	esac	
done


