#!/bin/bash

if ! grep -q '^[^#]*gpgcheck\s*=\s*1' /etc/yum.conf
then
  echo 'gpgcheck disabled in yum configuration by default'
  exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
