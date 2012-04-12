#!/usr/bin/env sh

#if[[ `whoami` -ne 'root' ]]
if [[ $UID -ne '0' ]]; then
    echo "You have to be logged as root to run this test!"
    exit $XCCDF_RESULT_ERROR
fi

output=$(chkrootkit -q)

if [[ "$output" == "" ]]; then
    exit $XCCDF_RESULT_PASS
else
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi
