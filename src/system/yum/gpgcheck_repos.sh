#!/bin/bash

RET=$XCCDF_RESULT_PASS

for repo in $(find /etc/yum.repos.d -maxdepth 1 -type f)
do
  if ! grep -q '^[^#]*gpgcheck\s*=\s*1' $repo
  then
    echo "gpgcheck disabled in $repo"
    RET=$XCCDF_RESULT_FAIL
  fi
done

exit $RET
