#!/bin/bash

HTOP_DEFAULT_VERSION="1.0.3"
HTOP_VERSION=$( htop --version 2>/dev/null | grep "^htop" | awk "{print \$2}" )
HTOP_CFG_DIR="$HOME/.config/htop"

cd $HTOP_CFG_DIR/ || (echo "ERROR: failed change dir to $HTOP_CFG_DIR/"; exit 1 )
if [[ -f htoprc-$HTOP_VERSION || -L htoprc-$HTOP_VERSION ]]; then
	unlink htoprc
	ln -s htoprc-$HTOP_VERSION htoprc
elif [[ -f htoprc-$HTOP_DEFAULT_VERSION || -L htoprc-$HTOP_DEFAULT_VERSION ]]; then
	unlink htoprc
	ln -s htoprc-$HTOP_DEFAULT_VERSION htoprc
else
	echo "ERROR: config file htoprc-$HTOP_VERSION or htoprc-$HTOP_DEFAULT_VERSION not found in $HTOP_CFG_DIR/"
	exit 1
fi
