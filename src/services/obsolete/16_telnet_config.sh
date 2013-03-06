#!/bin/sh

RET=${XCCDF_RESULT_PASS}

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
