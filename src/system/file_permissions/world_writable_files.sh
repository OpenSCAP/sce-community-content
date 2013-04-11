#!/usr/bin/env sh

output=$(
find / -path /proc -prune -o -type f -perm -0002 -printf "world writable file %p found\n" 2>/dev/null
)

# we captured output of the subshell, let's interpret it
if [ "$output" == "" ] ; then
    exit $XCCDF_RESULT_PASS
else
    # print the reason why we are failing
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi
