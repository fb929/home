#!/bin/bash

GROUP=$(id -gn)
if [[ -f $HOME/.puppetmaster ]]; then
    chmod 0711 $HOME
else
    chmod 0700 $HOME
fi
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

if [[ -f $HOME/.bash_history ]]; then
    chown $USER:$GROUP $HOME/.bash_history
fi

# gitconfig
if [[ -d $HOME/gpg/ ]]; then
    mv $HOME/.gitconfig.gpg $HOME/.gitconfig
fi
