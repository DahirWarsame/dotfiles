#!/usr/bin/env sh

# {{{
# Author:  Dahir "illwind" Warsame <yazure@dahirwarsame.me>
# License: GPLv3
# }}}

# {{{
setupSymlink()
{
	if [ -f "${HOME}/${1}" ] || [ -d "${HOME}/${1}" ]; then
		echo -e "\033[0;31m  Removing existing file at ${HOME}/${1}\033[0m"
		rm -r "${HOME}/${1}"
	fi

	echo -e "\033[0;32m  Creating symlink for ${HOME}/${1}\033[0m"
	ln -fs "${HOME}/dotfiles/home/illwind/${1}" "${HOME}/${1}"
}
# }}}

# {{{
setupDotDir()
{
	echo -e "\033[0;34m  Downloading ${1}.tar\033[0m"
	wget -O /tmp/${1}.tar http://dahirwarsame.me/dotfiles/${1}.tar 2> /dev/null

	if [ $? != 0 ]; then
		echo "\033[0;31m    Couldn't fetch ${1}!\033[0m"
		return
	fi

	if [ -d "${HOME}/.${1}" ]; then
		echo -e "\033[0;31m  Removing existing directory at ${HOME}/${1}\033[0m"
		rm -r "${HOME}/.${1}"
	fi

	echo -e "\033[0;32m  Creating dotdir for .${1}\033[0m"
	mkdir "${HOME}/.${1}"

	echo -e "\033[0;34m    Extracting ${1}.tar\033[0m"
	mv "/tmp/${1}.tar" "${HOME}/.${1}"
	cd "${HOME}/.${1}"
	tar xf "${1}.tar"

	echo -e "\033[0;34m    Cleaning up ${1}.tar\033[0m"
	rm "${1}.tar"

	cd - > /dev/null
}
# }}}

echo -e "Setting up dotfiles..."

# pull the git repo
if [ ! -d ~/dotfiles ]; then
	echo -e "\033[0;34mCloning into the repo...\033[0m"
	git clone --recursive https://github.com/dahirwarsame/dotfiles ~/dotfiles
else
	echo -e "\033[0;34mUpdating the repo...\033[0m"
	cd ~/dotfiles

	git pull
	git submodule init
	git submodule update

	cd - > /dev/null
fi

# create .config directory
if [ ! -d ~/.config ]; then
	echo -e "\033[0;34Creating directory ~/.config\033[0m"
	mkdir ~/.config
fi

# setup symlinks {{{

#TODO:
#setupSymlink ".config/gitignore"
#setupSymlink ".config/shell"
#setupSymlink ".config/sxhkd"
#setupSymlink ".config/tint2"
#setupSymlink ".config/tmux"
#setupSymlink ".mpdconf"
#setupSymlink ".ncmpcpp"
#setupSymlink ".scripts"
#setupSymlink ".tmux.conf"
#setupSymlink ".vim"
#setupSymlink ".weechat"
#setupSymlink ".xinit"
#setupSymlink ".Xmodmap"
#setupSymlink ".Xresources"
#setupSymlink ".zshrc"
#setupSymlink "snippets"

setupSymlink ".gitconfig"

# }}}

# setup dotfile dirs {{{
#setupDotDir "fonts"
# }}}

# setup ssh key
if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -b 4096 -C "`whoami`@`hostname -f`"
fi

echo "All done! Enjoy your system."
