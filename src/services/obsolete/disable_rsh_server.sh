#!/usr/bin/env sh

if rpm -q rsh-server
then
    echo "rsh-server is installed!"
    exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
