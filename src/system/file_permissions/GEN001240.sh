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
# original description: system command dirs must be owned by a system group

PATH=/bin:/usr/bin

# start a subshell
output=$(
find /bin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /sbin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /usr/bin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /usr/sbin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /usr/local/bin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /usr/local/sbin -type d \( ! -group root \) -printf "GEN001220: %p is group %g should be root\n" 2>/dev/null
find /usr/lib64/qt-3.3/bin -type d \( ! -group root \) -printf "GEN001220: %p is user %u should be root\n" 2>/dev/null
find /usr/java/j2re1.4.2_06/bin -type d \( ! -group root \) -printf "GEN001220: %p is user %u should be root\n" 2>/dev/null
)

# we captured output of the subshell, let's interpret it
if [ "$output" == "" ] ; then
    exit $XCCDF_RESULT_PASS
else
    # print the reason why we are failing
    echo "$output"
    exit $XCCDF_RESULT_FAIL
fi

