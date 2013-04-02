#!/usr/bin/env bash

VA_RANDOMIZATION=1

if [ ! -f /proc/sys/kernel/randomize_va_space ]
then
  echo 'WARNING: va randomization not found'
  exit $XCCDF_RESULT_NOT_APPLICABLE
fi

RET=$XCCDF_RESULT_PASS

# Check sysctl configuration file(s)
for config in /etc/sysctl.conf /etc/sysctl.d/*
do
  SETTING=$(cat $config | grep kernel.randomize_va_space | sed -e 's,[^#= ]\+\s*=\s*\([^#]\+\),\1,g')

  if [ $SETTING -ne $EXEC_SHIELD ]
  then
    echo "va randomization is disabled in $config"
    RET=$XCCDF_RESULT_FAIL
  fi
done

exit $RET
