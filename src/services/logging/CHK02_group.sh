#!/usr/bin/env bash

LOGFILES="/var/log/wtmp root utmp 664
	  /var/log/btmp root utmp 600
	  /var/log/lastlog root root 644
	  /var/run/utmp root utmp 664
	  /var/log/messages root root 600"

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
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
