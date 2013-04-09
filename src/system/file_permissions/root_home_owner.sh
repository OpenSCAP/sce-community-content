#!/usr/bin/env sh

OWNER=$(stat -c '%U' /root)

if [ $OWNER != 'root' ]
then
  echo "/root should be owned by root instead of $OWNER"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
