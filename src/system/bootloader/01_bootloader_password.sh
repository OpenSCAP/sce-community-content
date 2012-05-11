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

if [[ $UID -ne '0' ]]
then
    echo "You have to be logged as root to run this test!"
    exit ${XCCDF_RESULT_ERROR}
fi

if [[ "`egrep '^password' ${GRUBCONF} | wc -l`" == "0" ]]
then
	echo "${GRUBCONF} does not contain a password"
	echo "Please add the line 'password --md5 hash' to ${GRUBCONF}, where hash is output of grub-md5-crypt"	

	RET=$XCCDF_RESULT_FAIL
fi

exit $RET

