#!/usr/bin/env bash

LOGFILES="/var/log/wtmp root
    /var/log/btmp root
    /var/log/lastlog root
    /var/run/utmp root
    /var/log/messages root"

RET=$XCCDF_RESULT_PASS

while read name owner
do
  [ -e $name ] || continue

  REAL_OWNER=$(stat -c '%U' $name)
  if [ "x$REAL_OWNER" != "x$owner" ]
  then
    echo "File $name sahould be owned by owner $owner, not $REAL_OWNER"
    RET=$XCCDF_RESULT_FAIL
  fi
done <<_EOF
$LOGFILES
_EOF

exit $RET
