#!/usr/bin/env bash

CRONTAB="/etc/crontab"
CRON_SHELL="/bin/bash"
CRON_PATH_DIRS=(/bin /sbin /usr/bin /usr/sbin)

RET=${XCCDF_RESULT_PASS}

while read vars; do
    eval "${vars}"

    case "${VNAME}" in
        SHELL)
            if [[ "${VAR_SHELL}" != "${CRON_SHELL}" ]]; then
                echo "crontab variable SHELL is set to \"${VAR_SHELL}\". Expected value is \"${CRON_SHELL}\"."
                RET=$XCCDF_RESULT_FAIL
            fi
            ;;
        PATH)
            TMP=$IFS
            IFS=$'\n'
            EXP_DIRS=($((sort | uniq) <<< "${CRON_PATH_DIRS}"))
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
            ;;
    esac
done <<EOF
$(sed -n "s|^[[:space:]]*\([A-Z]*\)=\(.*\)[[:space:]]*$|VNAME=\"\1\" VAR_\1='\2'|p" "${CRONTAB}")
EOF

exit ${RET}
