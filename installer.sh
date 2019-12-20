#!/bin/bash

RESET='\033[0m'
BOLD='\033[01m'
GREEN='\033[32m'

curl -o ~/.cleaner.sh https://raw.githubusercontent.com/occulte/42Cleaner/master/cleaner.sh &> /dev/null
chmod +x ~/.cleaner.sh

function Add()
{
if ! grep "alias clean=\"~/.cleaner.sh\"" $HOME/$1 &> /dev/null
then
cat >> $HOME/$1 << EOL

# ――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# 42 CLeaner script ; https://github.com/occulte/42Cleaner
# ――――――――――――――――――――――――――――――――――――――――――――――――――――――――
alias clean="~/.cleaner.sh"

EOL
fi
}

BASHRC='.bash_profile' ; ZSHRC='.zshrc'

Add $BASHRC ; Add $ZSHRC

source $HOME/$BASHRC ; source $HOME/$ZSHRC

printf "${GREEN}${BOLD}‣ please open a new shell to finish installation!${RESET}\n"
