#!/usr/bin/env bash

CRONTAB="/etc/crontab"
CRON_PATH_DIRS=(/bin /sbin /usr/bin /usr/sbin)

RET=${XCCDF_RESULT_PASS}

while read VAR_PATH; do
    TMP=$IFS
    IFS=$'\n'
    EXP_DIRS=($((sort | uniq) <<< "${CRON_PATH_DIRS[*]}"))
    CUR_DIRS=($((tr ':' '\n' | sort | uniq) <<< "${VAR_PATH}"))
    IFS=$TMP

    for ((i=0; i < ${#EXP_DIRS[*]}; i++)); do
        if [[ -z "${CUR_DIRS[i]}" ]]; then
            echo "Missing directory \"${EXP_DIRS[i]}\" in PATH."
            RET=$XCCDF_RESULT_FAIL
            break
        fi

        if [[ "${CUR_DIRS[i]}" != "${EXP_DIRS[i]}" ]]; then
            if (( ${#CUR_DIRS[*]} < ${#EXP_DIRS[*]} )); then
                echo "Missing directory \"${EXP_DIRS[i]}\" in PATH."
                RET=$XCCDF_RESULT_FAIL
            else
                echo "Unexpected directory \"${CUR_DIRS[i]}\" found in PATH. Expected is \"${EXP_DIRS[i]}\"."
                RET=$XCCDF_RESULT_FAIL
            fi
            break;
        fi
    done
done <<EOF
$(sed -n "s|^[[:space:]]*PATH=\(.*\)[[:space:]]*$|\1|p" "${CRONTAB}")
EOF

exit ${RET}
