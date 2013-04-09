#!/usr/bin/env sh

if [ -e /etc/cron.allow ]
then
  GROUP=$(stat -c '%G' /etc/cron.allow)

  if [ $GROUP != 'root' ]
  then
    echo "/etc/cron.allow must be group-owned by root instead of $GROUP"
    exit $XCCDF_RESULT_FAIL
  fi
fi

if [ -e /etc/cron.deny ]
then
  GROUP=$(stat -c '%G' /etc/cron.deny)

  if [ $GROUP != 'root' ]
  then
    echo "/etc/cron.deny must be group-owned by root instead of $GROUP"
    exit $XCCDF_RESULT_FAIL
  fi
fi

exit $XCCDF_RESULT_PASS
