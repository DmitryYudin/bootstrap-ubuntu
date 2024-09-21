#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

APP=dbgate
DST=/opt/$APP

NAME=$APP/$APP
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=$APP-${TAG#v}-linux_x86_64.AppImage

if [[ -f $DST/$APP.desktop ]]; then
    VER=$(cat $DST/$APP.desktop | grep X-AppImage-Version= | cut -d= -f2 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -O
chmod a+x ./$BUNDLE

mkdir -p $DST
mountpoint=$(mktemp -d)
mount ./$BUNDLE $mountpoint -o offset=$(./$BUNDLE --appimage-offset)
rsync -avz $mountpoint/ $DST
umount $mountpoint
rmdir $mountpoint
rm $BUNDLE

APPDIR=/usr/local/share/applications
cp -f $DST/$APP.desktop $APPDIR/
sed -i s,Exec=.*,Exec=$DST/$APP, $APPDIR/$APP.desktop
sed -i s,Icon=.*,Icon=$DST/$APP.png, $APPDIR/$APP.desktop

cat <<EOT
-------------------------------------------------------------------------------
$(cat $DST/$APP.desktop | grep X-AppImage-Version=)
-------------------------------------------------------------------------------
EOT
