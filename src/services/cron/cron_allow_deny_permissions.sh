#!/usr/bin/env sh

if [ -e /etc/cron.allow ]
then
  ACCESS=$(stat -c '%a' /etc/cron.allow)

  if [ $ACCESS -ne 0600 ]
  then
    echo "/etc/cron.allow should have its permissions set to 0644 instead of 0$ACCESS"
    exit $XCCDF_RESULT_FAIL
  fi
fi

if [ -e /etc/cron.deny ]
then
  ACCESS=$(stat -c '%a' /etc/cron.deny)

  if [ $ACCESS -ne 0600 ]
  then
    echo "/etc/cron.deny should have its permissions set to 0644 instead of 0$ACCESS"
    exit $XCCDF_RESULT_FAIL
  fi
fi

exit $XCCDF_RESULT_PASS
