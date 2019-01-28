#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin

# usage
do_usage(){
	cat <<EOF

script for deploy home environment

usage: $0 [internal|external]

EOF
	exit 1
}

# vars
URL_VERSIONS="http://v.i/g.efimov/home/version.txt"
URL_RELEASES="https://api.github.com/repos/fb929/home/releases/latest"
URL_TAR_PREFIX_INT="http://v.i/g.efimov/home/v"
URL_TAR_PREFIX_EXT="https://github.com/fb929/home/archive/v"

# check user
if [[ $USER == root ]];then
	echo "ERROR: USER = root" 1>&2
	exit 1
fi

# check curl :\
CURL_OPTIONS="--fail --connect-timeout 1 --max-time 1"
if which .curl &>/dev/null; then
	CURL=".curl $CURL_OPTIONS"
elif which curl &>/dev/null; then
	CURL="curl $CURL_OPTIONS"
else
	echo "ERROR: programm curl not found"
	exit 1
fi

# check zones
# internal
VERSION=$( $CURL --silent $URL_VERSIONS )
if echo "$VERSION" | grep -qP "^[0-9\.]+$"; then
	URL_TAR_PREFIX=$URL_TAR_PREFIX_INT
else
	# external
	VERSION=$( $CURL --silent $URL_RELEASES | grep -Po '"tag_name": "\K.*?(?=")' | sed 's|^v||' )
	if echo "$VERSION" | grep -qP "^[0-9\.]+$"; then
		URL_TAR_PREFIX=$URL_TAR_PREFIX_EXT
	else
		echo "ERROR: failed version ($VERSION)"
		exit 1
	fi
fi


# check version
if [[ -s $HOME/.home_version ]]; then
	CURRENT_VERSION=$(cat $HOME/.home_version 2>/dev/null)
	if [[ $VERSION == $CURRENT_VERSION ]]; then
		# home in actual
		exit 0
	fi
fi
URL_TAR="${URL_TAR_PREFIX}${VERSION}.tar.gz"

# get and extract home tar
install -d $HOME/tmp/ &&
if [[ -d $HOME/tmp/home-$VERSION ]]; then
	rm -rf $HOME/tmp/home-$VERSION
fi
wget --quiet --output-document=$HOME/tmp/v$VERSION.tar.gz $URL_TAR &&
tar --gzip --extract --directory=$HOME/tmp/ --exclude=README.md --file=$HOME/tmp/v$VERSION.tar.gz &&
rsync -a $HOME/tmp/home-$VERSION/ $HOME/ &&
sh $HOME/bin/fixPerm.sh &&
sh $HOME/bin/fixHtopCfg.sh &&

# fix owner
tar --list --file=$HOME/tmp/v$VERSION.tar.gz | sed "s|home-$VERSION/|$HOME/|" | grep -v README.md | xargs chown $USER:$USER &&

# set home version
echo $VERSION > $HOME/.home_version
chown $USER:$USER $HOME/.home_version 2>/dev/null
