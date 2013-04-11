#!/bin/bash

FOUND=0

if ! grep -q '^\s*\*\s*hard\s*core\s*0\s*$' /etc/security/limits.conf
then
  echo 'No hard limitation found for core dumps in /etc/security/limits.conf'
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
