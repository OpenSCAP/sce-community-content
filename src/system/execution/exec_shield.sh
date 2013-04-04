#!/usr/bin/env bash

EXEC_SHIELD=1

if [ ! -f /proc/sys/kernel/exec-shield ]
then
  echo 'WARNING: exec-shield not found'
  exit $XCCDF_RESULT_NOT_APPLICABLE
fi

RET=$XCCDF_RESULT_PASS

# Check sysctl configuration file(s)
for config in $(ls -1 /etc/sysctl.conf /etc/sysctl.d/* 2>/dev/null)
do
  grep -q kernel.exec-shield $config || continue

  SETTING=$(cat $config | grep kernel.exec-shield | sed -e 's,[^#= ]\+\s*=\s*\([^#]\+\),\1,g')

  if [ $SETTING -ne $EXEC_SHIELD ]
  then
    echo "Exec-shield is disabled in $config"
    RET=$XCCDF_RESULT_FAIL
  fi
done

exit $RET
