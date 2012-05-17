#!/usr/bin/env sh

# This file is based on STIG file permission script by Steve Grub
#
# Copyright (c) 2011 Steve Grubb. ALL RIGHTS RESERVED.
# sgrubb@redhat.com
#
# This software may be freely redistributed under the terms of the GNU
# public license version 2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# In Feb 2011, DISA released UNIX Security Checklist Version 5,
# Release 1.28 to match with the OS SRG Unix.
# http://iase.disa.mil/stigs/downloads/zip/u_unix_v5r1-28_checklist_20110128.zip
# http://iase.disa.mil/stigs/downloads/zip/unclassified_os-srg-unix_v1r1_finalsrg.zip
#
# Modified by Martin Preisler <mpreisle@redhat.com> for use with XCCDF + SCE
#
# original description: syslog logs should be 0640 or less

PATH=/bin:/usr/bin

PERM_MASK=137
# allowing world readable logs isn't part of the STIG recommendation!
# nonetheless, it is common on desktops so we optionally allow this here
if [ "$XCCDF_VALUE_ALLOW_WORLD_READABLE" == "1" ]; then
    PERM_MASK=133
fi

PERM_ALLOWED=$[ 777 - $PERM_MASK ]

# start a subshell
output=$(
find /var/log -type f -perm /0${PERM_MASK} -printf "GEN001260: %p is %m should be ${PERM_ALLOWED} or less\n" 2>/dev/null | egrep -v 'wtmp|lastlog'
)

# we captured output of the subshell, let's interpret it
if [ "$output" == "" ] ; then
    exit $XCCDF_RESULT_PASS
else
    # print the reason why we are failing
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi

