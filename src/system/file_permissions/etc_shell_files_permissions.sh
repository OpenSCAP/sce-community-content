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
# original description: all shell files must be 0755 or less  ???

PATH=/bin:/usr/bin

# start a subshell
output=$(
find /etc -maxdepth 1 -type f -perm /0022 -name bashrc -printf "GEN001880: %p is %m should be 0755 or less\n" 2>/dev/null
find /etc -maxdepth 1 -type f -perm /0022 -name profile -printf "GEN001880: %p is %m should be 0755 or less\n" 2>/dev/null
find /etc/profile.d/ -type f -perm /0022 -printf "GEN001880: %p is %m should be 0755 or less\n" 2>/dev/null
)

# we captured output of the subshell, let's interpret it
if [ "$output" == "" ] ; then
    exit $XCCDF_RESULT_PASS
else
    # print the reason why we are failing
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi

