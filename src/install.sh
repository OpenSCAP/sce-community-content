#!/bin/sh

DESTDIR=$1

install -D -m 644 all-resolved-xccdf.xml $DESTDIR/usr/share/openscap/sce-community-content.xml
while read path
do
  install -D -m 755 $path $DESTDIR/usr/share/openscap/$path
done <<EOF
	`find . -mindepth 2 -name '*.sh'`
EOF
