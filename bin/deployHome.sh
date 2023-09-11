#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin

# usage
do_usage(){
    cat <<EOF 1>&2
script for deploy home environment
usage: $0 [internal|external]
EOF
    exit 1
}

# vars
GROUP=$(id -gn)
URL_RELEASES="https://api.github.com/repos/fb929/home/releases/latest"

# check user
if [[ $USER == root ]];then
    echo "ERROR: run user should be not a root" 1>&2
    exit 1
fi

# check curl
if which curl &>/dev/null; then
    CURL="curl --fail --connect-timeout 6 --max-time 30"
else
    echo "ERROR: program 'curl' not found" 1>&2
    exit 1
fi

# get version
VERSION=$( $CURL --silent $URL_RELEASES | grep '"tag_name":' | sed 's|.*":.*"v||; s|",||' )
if ! echo "$VERSION" | egrep -q "^[0-9\.]+$"; then
    echo "ERROR: failed get version='$VERSION'" 1>&2
    exit 1
fi

# check version
if [[ -s $HOME/.home_version ]]; then
    CURRENT_VERSION=$(cat $HOME/.home_version 2>/dev/null)
    if [[ $VERSION == $CURRENT_VERSION ]]; then
        # home in actual
        exit 0
    fi
fi

# url for tar
URL_TAR=$( $CURL --silent $URL_RELEASES | grep browser_download_url | awk '{print $NF}' )
if echo "$URL_TAR" | egrep -q "https://"; then
    echo "ERROR: bad url for tar='$URL_TAR'" 1>&2
    exit 1
fi

# get and extract home tar
install -d $HOME/tmp/ &&
if [[ -d $HOME/tmp/home-$VERSION ]]; then
    rm -rf $HOME/tmp/home-$VERSION
fi
$CURL --silent --location --output $HOME/tmp/v$VERSION.tar.gz $URL_TAR &&
tar --gzip --extract --directory=$HOME/tmp/ --exclude=README.md --file=$HOME/tmp/v$VERSION.tar.gz &&
rsync -a $HOME/tmp/home-$VERSION/ $HOME/ &&
bash $HOME/bin/fixPerm.sh &&
bash $HOME/bin/fixHtopCfg.sh &&

# fix owner
tar --list --file=$HOME/tmp/v$VERSION.tar.gz | sed "s|home-$VERSION/|$HOME/|" | egrep -v README.md | xargs chown $USER:$GROUP &&

# set home version
echo $VERSION > $HOME/.home_version
chown $USER:$GROUP $HOME/.home_version 2>/dev/null
