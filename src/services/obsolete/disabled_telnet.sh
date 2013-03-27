#!/bin/sh

RET=${XCCDF_RESULT_PASS}

if rpm -qf telnet-server >/dev/null 2>&1
then
    echo "The telnet server is installed!"
    exit $XCCDF_RESULT_FAIL
fi

exit ${RET}
