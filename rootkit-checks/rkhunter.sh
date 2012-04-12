#!/usr/bin/env sh

#if[[ `whoami` -ne 'root' ]]
if [[ $UID -ne '0' ]]; then
    echo "You have to be logged as root to run this test!"
    exit $XCCDF_RESULT_ERROR
fi

output=$(rkhunter --check --quiet --sk --display-logfile)

echo "$output"
if [[ "$?" == "0" ]]; then
    exit $XCCDF_RESULT_PASS
else
    exit $XCCDF_RESULT_FAIL
fi
