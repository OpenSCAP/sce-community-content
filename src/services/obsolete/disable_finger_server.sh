#!/usr/bin/env sh

if rpm -q finger-server
then
    echo "finger-server is installed!"
    exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
