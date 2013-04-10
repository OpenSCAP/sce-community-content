#!/usr/bin/env sh

ACCESS=$(stat -c '%a' /etc/group)

if [ $ACCESS -ne 0644 ]
then
  echo "/etc/group should have its permissions set to 0644 instead of 0$ACCESS"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
