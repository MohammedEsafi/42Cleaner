#!/bin/bash

WIDTH=40

RESET='\033[0m'
BOLD='\033[01m'
DISABLE='\033[02m'
ITALIC='\033[03m'
UNDERLINE='\033[04m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
LIGHT_YELLOW='\033[93m'

# usage
ARGC=$#
if [[ $1 == "--version" ]]; then
    echo "1.0.0"
    exit
fi
if [ $ARGC -ne '0' ]; then
    printf "usage: clean                  clean ${ITALIC}${USER}${RESET} user caches & temporary files\n"
    echo   "       clean -h --help        show this help message."
    echo   "       clean --version        show version."
    exit
fi

# convert bytes to lowest possible value
CUT_SHORT() {
    WHOLE=${1:-0};
    FRACTION='';
    SIGN=({K,M,G,T,E,P,Y,Z}B)
    INDEX=0
    while ((WHOLE >= 1024)); do
        if ((WHOLE < 2048)); then
            FRACTION="$(printf ".%02d" $((WHOLE % 1024 * 100 / 1024)))"
        fi
        WHOLE=$((WHOLE / 1024))
        (( INDEX++ ))
    done
    printf "${GREEN}${BOLD}‣ well done! ${RESET}${ITALIC}${WHOLE}${FRACTION} ${SIGN[$INDEX]}${RESET} of space was cleaned up\n"
}

# space size before cleaning
S_BEFORE=$(du -s $HOME 2> /dev/null | tail -1 | awk '{print $1}')

# cleanup 42 caches files
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup 42 caches files…"
rm -rf ~/*42*cache* &> /dev/null
rm -rf ~/.*42* &> /dev/null
rm -rf ~/Library/*42* &> /dev/null
rm -rf ~/Library/.*42* &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# clearing the QuickLook cache
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "clearing the QuickLook cache…"
qlmanage -r cache &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# empty the trash
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "empty the trash…"
rm -rf ~/.Trash/* &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup user caches & logs files
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "clear system log files…"
rm -rf ~/Library/Caches/* &> /dev/null
rm -rf ~/Library/logs/* &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup vs code caches
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup vs code caches…"
rm -rf ~/Library/Application\ Support/Code/Cache/* &> /dev/null
rm -rf ~/Library/Application\ Support/Code/CachedData/* &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup XCode derived data and archives
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "XCode derived data and archives…"
rm -rf ~/Library/Developer/Xcode/DerivedData/* &> /dev/null
rm -rf ~/Library/Developer/Xcode/Archives/* &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup pip cache
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup pip cache…"
rm -rfv ~/Library/Caches/pip &> /dev/null
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup homebrew cache
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup homebrew cache…"
if type "brew" &> /dev/null; then
    brew cleanup -s &> /dev/null
    brew cask cleanup &> /dev/null
    rm -rf $(brew --cache) &> /dev/null
    brew tap --repair &> /dev/null
fi
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup npm cache
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup npm cache…"
if type "npm" &> /dev/null; then
    npm cache clean --force &> /dev/null
fi
printf "${GREEN}${BOLD}✔${RESET}\n"

# cleanup yarn cache
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "cleanup yarn cache…"
if type "yarn" &> /dev/null; then
    yarn cache clean --force &> /dev/null
fi
printf "${GREEN}${BOLD}✔${RESET}\n"

# applications caches
printf "‣ ${ITALIC}%-*s${RESET}" "$WIDTH" "applications caches…"
for App in $(ls ~/Library/Containers/); do 
    rm -rf ~/Library/Containers/$App/Data/Library/Caches/* &> /dev/null
done
printf "${GREEN}${BOLD}✔${RESET}\n"

# space size after cleaning
S_AFTER=$(du -s $HOME 2> /dev/null | tail -1 | awk '{print $1}')

# finished
COUNT=$((S_BEFORE - S_AFTER))
if [ $COUNT -le -1 ]; then
    COUNT=0
else
    COUNT=$((COUNT / 2))
fi
CUT_SHORT $COUNT
