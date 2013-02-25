#!/usr/bin/env bash

# -------------------------------- #
# Copyright (C) 2008 Red Hat, Inc.
# Written by Dan Kopecek <dkopecek@redhat.com>
# Adapted for SCE by Martin Preisler <mpreisle@redhat.com>

RET=$XCCDF_RESULT_PASS

# For now we are storing these hardcoded in here,
# but we would like to pass them as XCCDF bound variables in the future!
DIRECTORY_LIST="/bin
		/sbin
		/lib
		/usr/bin
		/usr/sbin
		/usr/lib
		/usr/libexec
		/tmp
		/proc
		/var"

while read dir; do
	if [[ ! -d "${dir}" ]]; then
	    echo "Directory \"${dir}\" does not exist!"
	    RET=${XCCDF_RESULT_FAIL}
	fi
done <<EOF
${DIRECTORY_LIST}
EOF

exit $RET
