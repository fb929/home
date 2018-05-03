#!/bin/bash

chmod 0710 $HOME
chmod 0700 \
	$HOME/.ssh/ \
	$HOME/.bash-git-prompt/ \

chmod 0600 \
	$HOME/.ssh/authorized_keys \
	$HOME/.screenrc \
	$HOME/.vimrc \
	$HOME/.gitconfig \
	$HOME/.bash_history \
	$HOME/.bash_logout \
	$HOME/.bash_profile \
	$HOME/.bashrc \
	$HOME/.git-completion.sh \
	$HOME/.gitconfig \

chmod -R 0750 $HOME/bin/
