#!/bin/bash

DEFAULT_VERSION=$( cat $HOME/.home_version )
VERSION=${1:-$DEFAULT_VERSION}

if ! echo "$VERSION" | grep -qP "^[0-9\.]+$"; then
	cat <<EOF
usage: $0 [version]
example:
	$0 $DEFAULT_VERSION
EOF
	exit 1
fi

install -d $HOME/tmp/ &&
if [[ -d $HOME/tmp/home-$VERSION ]]; then
	rm -rf $HOME/tmp/home-$VERSION
fi
wget --quiet --output-document=$HOME/tmp/v$VERSION.tar.gz https://github.com/fb929/home/archive/v$VERSION.tar.gz &&
tar --gzip --extract --directory=$HOME/tmp/ --exclude=README.md --file=$HOME/tmp/v$VERSION.tar.gz &&
rsync -a $HOME/tmp/home-$VERSION/ $HOME/
sh $HOME/bin/fixPerm.sh
chown -R $USER:$USER $HOME
echo $VERSION > $HOME/.home_version


