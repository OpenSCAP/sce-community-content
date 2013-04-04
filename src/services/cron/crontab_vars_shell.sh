#!/usr/bin/env bash

CRONTAB="/etc/crontab"
CRON_SHELL="/bin/bash"

RET=${XCCDF_RESULT_PASS}

while read VAR_SHELL; do
    if [[ "${VAR_SHELL}" != "${CRON_SHELL}" ]]; then
        echo "crontab variable SHELL is set to \"${VAR_SHELL}\". Expected value is \"${CRON_SHELL}\"."
        RET=$XCCDF_RESULT_FAIL
    fi
done <<EOF
$(sed -n "s|^[[:space:]]*SHELL=\(.*\)[[:space:]]*$|\1|p" "${CRONTAB}")
EOF

exit ${RET}
