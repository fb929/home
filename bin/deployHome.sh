#!/bin/bash

VERSION=${1:-"0.1"}

install -d $HOME/tmp/ &&
if [[ -d $HOME/tmp/home-$VERSION ]]; then
	rm -rf $HOME/tmp/home-$VERSION
fi
wget --quiet --output-document=$HOME/tmp/v$VERSION.tar.gz https://github.com/fb929/home/archive/v$VERSION.tar.gz &&
tar --gzip --extract --directory=$HOME/tmp/ --exclude=README.md --file=$HOME/tmp/v$VERSION.tar.gz &&
rsync -a $HOME/tmp/home-$VERSION/ $HOME/
echo $VERSION > $HOME/.home_version
