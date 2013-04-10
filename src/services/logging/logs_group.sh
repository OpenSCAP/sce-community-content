#!/usr/bin/env bash

LOGFILES="/var/log/wtmp utmp
	  /var/log/btmp utmp
	  /var/log/lastlog root
	  /var/run/utmp utmp
	  /var/log/messages root"

RET=$XCCDF_RESULT_PASS

while read name group
do
  [ -e $name ] || continue

  REAL_GROUP=$(stat -c '%G' $name)
  if [ "x$REAL_GROUP" != "x$group" ]
  then
    echo "File $name sahould be owned by group $group, not $REAL_GROUP"
    RET=$XCCDF_RESULT_FAIL
  fi
done <<_EOF
$LOGFILES
_EOF

exit $RET
