#!/usr/bin/env sh

if [ -z "$ENABLE_GROUP_READABLE" ]
then
  ENABLE_GROUP_READABLE=1
fi

EXPECTED_PERMISSION=0700
if [ $ENABLE_GROUP_READABLE -eq 1 ]
then
  EXPECTED_PERMISSION=0750
fi

ACCESS=$(stat -c '0%a' /root)

if [ $ACCESS -ne $EXPECTED_PERMISSION ]
then
  echo "/root should have its permissions set to $EXPECTED_PERMISSION instead of $ACCESS"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
