#!/usr/bin/env bash

LOGFILES="/var/log/wtmp root utmp 664
    /var/log/btmp root utmp 600
    /var/log/lastlog root root 644
    /var/run/utmp root utmp 664
    /var/log/messages root root 600"

RET=$XCCDF_RESULT_PASS

while read name owner group perm
do
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
