# home
deploy:  
```
URL="https://api.github.com/repos/fb929/home/releases/latest"
VERSION=$( curl --silent $URL | grep -Po '"tag_name": "\K.*?(?=")' | sed 's|^v||' )
if ! echo "$VERSION" | grep -qP "^[0-9\.]+$"; then
	echo "ERROR: failed get version from $URL"
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
echo $VERSION > $HOME/.home_version
```

or run bin/deployHome.sh
