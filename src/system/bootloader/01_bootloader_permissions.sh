#!/usr/bin/env bash

# ----------------------------------------------------------- #
# Copyright (C) 2008 Red Hat, Inc.                            #
# Written by Michel Samia <msamia@redhat.com>                 #
# Adapted for SCE by Martin Preisler <mpreisle@redhat.com>    #
# bootloader.sh                                               #
# ----------------------------------------------------------- #

RET=$XCCDF_RESULT_PASS

GRUBCONF=/boot/grub2/grub.cfg

if [ ! -f ${GRUBCONF} ]; then
    # try the legacy grub.conf location
    GRUBCONF=/boot/grub/grub.conf
fi

if [ ! -f ${GRUBCONF} ]; then
    # still can't find it, we can't proceed with the check
    echo "Can't find the grub.{cfg,conf} file!"
    exit $XCCDF_RESULT_ERROR
fi

function check_file_perm () {
    if [[ -a "${1}" ]]; then
        local -i CPERM=$(stat -L -c '%a' "${1}")

        if (( ${CPERM} != $2 )); then
            if (( (8#${CPERM} | 8#${2}) == 8#${2} )); then
                if (( ${4} == 1 )); then
                    echo "Permissions on $(stat -c '%F' "${1}") \"${1}\" are more restrictive than required: ${CPERM} (${6:-uknown}, required persmissions are ${2})"
                fi
            else
                if (( ${4} == 1 )); then
                    echo "Wrong permissions on $(stat -c '%F' "${1}") \"${1}\": ${CPERM} (${6:-unknown}, required permissions are ${2})"
                    RET=$XCCDF_RESULT_FAIL
                fi
            fi
        fi

        if ! (stat -L -c '%U:%G' "${1}" | grep -q "${3}"); then
            if (( ${4} == 1 )); then
                echo "Wrong owner/group on $(stat -c '%F' "${1}"): \"${1}\" (${6:-unknown}, required owner/group is ${3})"
                RET=$XCCDF_RESULT_FAIL
            fi
        fi
    else
        if (( ${4} == 1 )); then
            echo "Missing file or directory: \"${1}\" (${6:-unknown})"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi
}

if [[ $UID -ne '0' ]]
then
    echo "You have to be logged as root to run this test!"
    exit ${XCCDF_RESULT_ERROR}
fi

check_file_perm ${GRUBCONF} 600 root:root 1 $E_BAD_PERMISSIONS "Bootloader configuration file"

exit $RET

