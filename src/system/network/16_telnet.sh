#!/bin/sh

RET=${XCCDF_RESULT_PASS}

# Check if a telnet service is running
SERVICE=$(netstat -tlnup 2>/dev/null | grep telnetd | wc -l)

if [ $SERVICE -gt 0 ]
then
    echo "A stand-alone telnet server seems to be running"
    RET=${XCCDF_RESULT_FAIL}
fi

PORT=$(netstat -tlup 2>/dev/null | grep LISTEN | grep telnet | wc -l)
if [ $PORT -gt 0 ]
then
    echo "Some services are listening on a telnet port"
    RET=${XCCDF_RESULT_FAIL}
fi

# Check if an xinetd telnet service is present and disabled
if [ -f /etc/xinetd.d/telnet ]
then
    DISABLED=$(sed -n 's,^\s\+disable\s\+=\s\+\(yes\|no\).*$,\1,p' /etc/xinetd.d/telnet)

    if [ "x$DISABLED" != "xyes" ]
    then
        echo "An xinetd telnet server seems to be enabled"
        RET=${XCCDF_RESULT_FAIL}
    fi
fi

exit ${RET}
