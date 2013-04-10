#!/usr/bin/env sh

OWNER=$(stat -c '%U' /etc/group)

if [ $OWNER != 'root' ]
then
  echo "The owner of /etc/group should be root instead of $OWNER"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
