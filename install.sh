#!/bin/bash


echo "Installing repo packages"
echo ""
git clone https://github.com/RazeSevi/spicetify-themes.git
echo ""
echo "installing spicetify"
echo ""
yay -S spicetify-cli
echo ""
echo "Done"

cd spicetify-themes
cp -r * ~/.config/spicetify/Themes
