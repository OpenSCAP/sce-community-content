#!/usr/bin/env bash

# ----------------------------------------------------------- #
# Copyright (C) 2008 Red Hat, Inc.                            #
# Written by Michel Samia <msamia@redhat.com>                 #
# Adapted for SCE by Martin Preisler <mpreisle@redhat.com>    #
# disc_usage.sh                                               #
# more info in disc_usage.dsc                                 #
# ----------------------------------------------------------- #

# secTool script testing directories from standarad hierarchy for presence, permissions and owner
# for more info about FHS see http://www.pathname.com/fhs/pub/fhs-2.3.html

# list of pairs - absolute path of the directory and a permission mask
dirs="/ 222
/bin 222
/boot 222
/dev 022
/etc 022
/home 022
/lib 222
/media 022
/mnt 022
/opt 022
/root 227
/sbin 222
/srv 022
/usr 022
/usr/bin 222
/usr/sbin 222
/usr/include 022
/usr/lib 222
/usr/share 022
/usr/src 022
/usr/local 022
/var 022
/var/lock 002
/var/log 022
/var/run 022
/var/spool 022
/var/spool/mail 002
"

ret=$XCCDF_RESULT_PASS

while read dir perm_mask
do
    #echo "dir: $dir   perm: $perm"
    [ "$dir" == "" ] && continue

    # exists?
    if ! [[ -d $dir ]]; then
        echo "Directory $dir doesn't exist! Please create it."

        ret=$XCCDF_RESULT_FAIL
    else
        current_owner=$(stat -L -c '%U' $dir)
        if [[ "$current_owner" != "root" ]]; then
            echo "Directory $dir has wrong owner. Change the owner from \"$current_owner\" to root."
            ret=$XCCDF_RESULT_FAIL
        fi

        current_permissions=$(stat -L -c '%a' $dir)
        find_result=$(find -H "$dir" -maxdepth 0 -type d -perm /$perm_mask)
        if [[ "$find_result" != "" ]]; then
            perms=$[777-$perm_mask]
            echo "Directory $dir has wrong permissions! Change the permissions from $current_permissions to $perms or stricter."
            ret=$XCCDF_RESULT_FAIL
        fi
    fi
done <<EOF
$dirs
EOF

exit $ret

