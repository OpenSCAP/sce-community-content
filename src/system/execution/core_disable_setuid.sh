#!/usr/bin/env bash

RET=$XCCDF_RESULT_PASS
FOUND=0

# Check sysctl configuration file(s)
for config in $(ls -1 /etc/sysctl.conf /etc/sysctl.d/* 2>/dev/null)
do
  grep -q fs.suid_dumpable $config || continue

  SETTING=$(cat $config | grep fs.suid_dumpable | sed -e 's,[^#= ]\+\s*=\s*\([^#]\+\),\1,g')
  FOUND=1

  if [ $SETTING -eq 0 ]
  then
    echo "Core dumps for SUID executables are enabled in $config"
    RET=$XCCDF_RESULT_FAIL
  fi
done

if [ $FOUND -eq 0 ]
then
  echo "No explicit disable found for SUID dumpable in sysctl configs"
  RET=$XCCDF_RESULT_FAIL
fi

exit $RET
