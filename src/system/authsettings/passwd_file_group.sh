#!/usr/bin/env sh

GROUP=$(stat -c '%G' /etc/passwd)

if [ $GROUP != 'root' ]
then
  echo "The group-owner of /etc/passwd should be root instead of $GROUP"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
