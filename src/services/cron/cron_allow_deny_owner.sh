#!/usr/bin/env sh

if [ -e /etc/cron.allow ]
then
  OWNER=$(stat -c '%U' /etc/cron.allow)

  if [ $OWNER != 'root' ]
  then
    echo "/etc/cron.allow must be owned by root instead of $OWNER"
    exit $XCCDF_RESULT_FAIL
  fi
fi

if [ -e /etc/cron.deny ]
then
  OWNER=$(stat -c '%U' /etc/cron.deny)

  if [ $OWNER != 'root' ]
  then
    echo "/etc/cron.deny must be owned by root instead of $OWNER"
    exit $XCCDF_RESULT_FAIL
  fi
fi

exit $XCCDF_RESULT_PASS
