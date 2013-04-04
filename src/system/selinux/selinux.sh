#!/usr/bin/env bash

SELINUX_CONFIG='/etc/selinux/config'

if [[ -z "$XCCDF_VALUE_EXPECTED_STATE" ]]; then
    XCCDF_VALUE_EXPECTED_STATE="enforcing"
    echo "WARNING: Using default expected state!"
else
    XCCDF_VALUE_EXPECTED_STATE="$(echo $XCCDF_VALUE_EXPECTED_STATE | tr '[A-Z]' '[a-z]')"
fi

if [ ! -f $SELINUX_CONFIG ]
then
    echo 'Missing SELinux configuration file'
    exit $XCCDF_RESULT_NOT_APPLICABLE
fi

SELINUX_STATE=$(cat $SELINUX_CONFIG | sed -n 's,^[^#]*SELINUX=\([a-zA-Z0-9]*\)$,\1,p')

if [ $SELINUX_STATE != $XCCDF_VALUE_EXPECTED_STATE ]
then
    echo "SELinux must be set to '$XCCDF_VALUE_EXPECTED_STATE' instead of $SELINUX_STATE"
    exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
