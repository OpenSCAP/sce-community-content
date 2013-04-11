#!/bin/bash

RET=$XCCDF_RESULT_PASS

while read name uid
do
  if [ "x$uid" = "x0" -a "x$name" != "xroot" ]
  then
    echo "User $name has a zero UID, only roots should have this"
    RET=$XCCDF_RESULT_FAIL
  fi
done << _EOF
$(cat /etc/passwd | cut -d: -f 1,3 | tr ':' ' ')
_EOF

exit $RET
