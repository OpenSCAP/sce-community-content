#!/bin/sh

DESTDIR=$1

install -D -m 644 all-resolved-xccdf.xml $DESTDIR/usr/share/openscap/sce-community-content.xml
install -D -m 644 guide.html $DESTDIR/usr/share/doc/sce-community-content-1.0/guide.html
while read path
do
  install -D -m 755 $path $DESTDIR/usr/share/openscap/$path
done <<EOF
	`find . -mindepth 2 -name '*.sh'`
EOF
