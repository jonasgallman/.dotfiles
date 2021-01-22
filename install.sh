#!/bin/zsh

############
# includes #
############

source ./colors.sh
source ./install_functions.sh
source ./zsh/zshenv

###########
# welcome #
###########
echo -e "
${blue}
 _______ _______ _______ _______ _______
|__     |   |   |    ___|    |  |_     _|
|     __|   |   |    ___|       |_|   |_
|_______|_______|_______|__|____|_______|
${light_blue}               <.dotfiles>
"

echo -e "${yellow}             --- ${red}WARNING ${yellow}---"

if [ $# -ne 1 ] || [ "$1" !="-y" ];
    then
        echo -e "${yellow}        Continue at your own risk...\n"
        read key;
fi

###########
# install #
###########

. $DOTFILES/install/install-zsh.sh

dot_is_installed nvim && dot_install nvim
dot_is_installed go && dot_install_func go install_go_binaries
dot_is_installed git && dot_install git
