# home
deploy:  
```
URL="https://api.github.com/repos/fb929/home/releases/latest"
CURL_OPTIONS="--fail --connect-timeout 1 --max-time 1"
CURL="curl $CURL_OPTIONS"
VERSION=$( $CURL --silent $URL | grep -Po '"tag_name": "\K.*?(?=")' | sed 's|^v||' )
if ! echo "$VERSION" | grep -qP "^[0-9\.]+$"; then
	echo "ERROR: failed get version from $URL"
	exit 1
fi
if [[ -s $HOME/.home_version ]]; then
	CURRENT_VERSION=$(cat $HOME/.home_version )
	if [[ $VERSION == $CURRENT_VERSION ]]; then
		# home in actual
		exit 0
	fi
fi

install -d $HOME/tmp/ &&
if [[ -d $HOME/tmp/home-$VERSION ]]; then
	rm -rf $HOME/tmp/home-$VERSION
fi
wget --quiet --output-document=$HOME/tmp/v$VERSION.tar.gz https://github.com/fb929/home/archive/v$VERSION.tar.gz &&
tar --gzip --extract --directory=$HOME/tmp/ --exclude=README.md --file=$HOME/tmp/v$VERSION.tar.gz &&
rsync -a $HOME/tmp/home-$VERSION/ $HOME/
sh $HOME/bin/fixPerm.sh
sh $HOME/bin/fixHtopCfg.sh &&

# fix owner
tar --list --file=$HOME/tmp/v$VERSION.tar.gz | sed "s|home-$VERSION/|$HOME/|" | grep -v README.md | xargs chown $USER:$USER &&

echo $VERSION > $HOME/.home_version
```

or run bin/deployHome.sh
