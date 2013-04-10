#!/usr/bin/env sh

GROUP=$(stat -c '%G' /etc/gshadow)

if [ $GROUP != 'root' ]
then
  echo "The group-owner of /etc/gshadow should be root instead of $GROUP"
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
