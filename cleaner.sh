#!/bin/bash

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
    SIGN=(B {K,M,G,T,E,P,Y,Z}B)
    INDEX=0
    while ((WHOLE > 1024)); do
        WHOLE=$((WHOLE / 1024))
        if ((WHOLE < 1024)); then
            FRACTION="$(printf ".%02d" $((WHOLE % 1024 * 100 / 1024)))"
        fi
        (( INDEX++ ))
    done
    printf "${GREEN}${BOLD}‣ well done! ${RESET}${ITALIC}${WHOLE}${FRACTION} ${SIGN[$INDEX]}${RESET} of space was cleaned up\n"
}

# space size before cleaning
S_BEFORE=$(df $HOME | tail -1 | awk '{print $4}')

# cleanup 42 caches files
rm -rf ~/*4* &> /dev/null
rm -rf ~/.*4* &> /dev/null
rm -rf ~/Library/*4* &> /dev/null
rm -rf ~/Library/.*4* &> /dev/null
# clearing the QuickLook cache
qlmanage -r cache &> /dev/null
# empty the trash
rm -rf ~/.Trash/* &> /dev/null
# cleanup user caches files
rm -rf ~/Library/Caches/* &> /dev/null
# cleanup user logs
rm -rf ~/Library/logs/* &> /dev/null
# cleanup vs code caches
rm -rf ~/Library/Application\ Support/Code/Cache/* &> /dev/null
rm -rf ~/Library/Application\ Support/Code/CachedData/* &> /dev/null
# cleanup XCode derived data and archives
rm -rf ~/Library/Developer/Xcode/DerivedData/* &> /dev/null
rm -rf ~/Library/Developer/Xcode/Archives/* &> /dev/null
# cleanup pip cache
rm -rfv ~/Library/Caches/pip &> /dev/null
# cleanup homebrew cache
if type "brew" &> /dev/null; then
    brew cleanup -s &> /dev/null
    brew cask cleanup &> /dev/null
    rm -rf $(brew --cache) &> /dev/null
    brew tap --repair &> /dev/null
fi
# cleanup npm cache
if type "npm" &> /dev/null; then
    npm cache clean --force &> /dev/null
fi
# cleanup yarn cache
if type "yarn" &> /dev/null; then
    yarn cache clean --force &> /dev/null
fi
# applications caches
for App in $(ls ~/Library/Containers/); do 
    rm -rf ~/Library/Containers/$App/Data/Library/Caches/* &> /dev/null
done

# space size after cleaning
S_AFTER=$(df $HOME | tail -1 | awk '{print $4}')

# finished
COUNT=$((S_BEFORE - S_AFTER))
if ((${COUNT:-0} < 0)); then
    COUNT=0
fi
CUT_SHORT $COUNT
