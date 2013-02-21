#!/bin/sh

output=$(
find /bin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /sbin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/bin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/sbin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/local/bin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/local/sbin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/lib64/qt-3.3/bin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
find /usr/java/j2re1.4.2_06/bin -type f ! -user root -printf 'PCI-DSS: %p is not owned by root\n' 2>/dev/null
)

# we captured output of the subshell, let's interpret it
if [ "$output" == "" ] ; then
    exit $XCCDF_RESULT_PASS
else
    # print the reason why we are failing
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi

