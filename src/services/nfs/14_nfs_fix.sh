#!/bin/sh

EXPORTS="/etc/exports"

if [ ! -e $EXPORTS ]
then
  touch $EXPORTS
  chmod 0644 $EXPORTS
  exit 0
fi

if [ ! -f $EXPORTS ]
then
  echo "$EXPORTS not a file"
  exit 1
fi

TEMPFILE=$(mktemp)
sed -e 's|\([(,]\)rw\([),]\)|\1ro\2|g' < $EXPORTS > $TEMPFILE
mv $TEMPFILE $EXPORTS
chmod 0644 $EXPORTS
