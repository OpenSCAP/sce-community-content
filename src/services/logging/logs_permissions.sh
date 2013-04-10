#!/bin/bash

if [ -z $ENABLE_WORLD_READABLE ]
then
  ENABLE_WORLD_READABLE=1
  echo 'ENABLE_WORLD_READABLE not set properly, using default value'
fi

EXPECTED_PERMISSION=0640
if [ $ENABLE_WORLD_READABLE -eq 1 ]
then
  EXPECTED_PERMISSION=0644
fi

LOGFILES="/var/log/wtmp 664
	  /var/log/btmp 600
	  /var/log/lastlog $EXPECTED_PERMISSION
	  /var/run/utmp 664
	  /var/log/messages $EXPECTED_PERMISSION"

RET=$XCCDF_RESULT_PASS

while read name perm
do
  [ -e $name ] || continue

  ACCESS=$(stat -c '%a' $name)

  if [ $ACCESS -ne $perm ]
  then
    echo "$name has invalid permissions, expected $perm, got $EXPECTED_PERMISSION"
    RET=$XCCDF_RESULT_FAIL
  fi
done <<_EOF
$LOGFILES
_EOF

exit $RET
