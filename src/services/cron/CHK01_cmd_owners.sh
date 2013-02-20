#!/usr/bin/env bash

CRONTAB="/etc/crontab"
CRON_CMD_OWNER="root:root"

RET=${XCCDF_RESULT_PASS}

while read vars; do
    eval "${vars}"

    if [[ -z "${CMD}" ]]; then
    continue
    fi

    case "${CMD}" in
    /*)
        CMDPATH="${CMD}"
        ;;
    *)
        CMDPATH="$(which "${CMD}")"
        ;;
    esac

    CMDOWNER="$(stat -c "%U:%G" "${CMDPATH}")"

    echo ${vars} $CMDOWNER

    if ! (echo "${CMDOWNER}" | grep -q "${CRON_CMD_OWNER}"); then
        echo "Wrong owner/group \"${CMDOWNER}\" on \"${CMDPATH}\". Expected is \"${CRON_CMD_OWNER}\"."
        RET=$XCCDF_RESULT_FAIL
    fi
done <<EOF
$(sed -n -e "s|^\([0-9\*,-]\+\)[[:space:]]\+\([0-9\*,-]\+\)[[:space:]]\+\([0-9\*,-]\+\)[[:space:]]\+\([0-9\*,-]\+\)[[:space:]]\+\([0-9\*,-]\+\)[[:space:]]\+\([a-zA-Z0-9_-]*\)[[:space:]]\+\([^;\$[:space:]]\+\)[[:space:]]*\(.*\)$|MIN=\"\1\" HRS=\"\2\" DAYM=\"\3\" DAYW=\"\4\" MON=\"\5\" USER=\"\6\" CMD='\7' CMDARGS='\8'|p" "${CRONTAB}")
EOF

exit ${RET}
