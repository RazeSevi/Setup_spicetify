#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' 

if ! [[ -d spicetify-themes ]]; then

	echo -e "${GREEN}Installing repo packages${NC}"
	echo ""
	git clone https://github.com/RazeSevi/spicetify-themes.git
	echo ""
else
	echo -e "${GREEN}Repo packages are already installed.${NC}"
fi

if ! yay -Q spicetify-cli 2>/dev/null 1>/dev/null; then
	echo -e"${GREEN}installing spicetify${NC}"
	echo ""
	yay -S spicetify-cli
	echo ""
	echo -e "${GREEN}Done${NC}"
else
	echo -e "${GREEN}Spicetify-cli is already installed.${NC}"
fi
cd spicetify-themes
cp -r * ~/.config/spicetify/Themes

#If you want to set your own theme, you have ta create your own theme in ~/.config/spicetify/Themes. 
# Not in the cloned directory.
