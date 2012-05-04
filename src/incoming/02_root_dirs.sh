#!/usr/bin/env bash
#
# Copyright (C) 2008 Red Hat, Inc.
# Written by Peter Vrabec <pvrabec@redhat.com>
# Adapted for SCE by Martin Preisler <mpreisle@redhat.com

RET=$XCCDF_RESULT_PASS

for dir in $(find / -maxdepth 1 -type d -name '.*'); do
	echo "There should not be a \"${dir}\" directory under \"/\""
	RET=$XCCDF_RESULT_FAIL
done

exit $RET

