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

exit ${RET}
