#!/usr/bin/env bash

# Copied from 08_permissions.sh

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

while read dir perm_mask
do
    [ "$dir" == "" ] && continue

    if [ ! -d $dir ]
    then
      # If directory does not exist, create it!

      mkdir $dir
    fi

    current_owner=$(stat -L -c '%U' $dir)
    if [ "$current_owner" != 'root' ]
    then
      # Change the directory owner

      chown root $dir
    fi

    find_result=$(find -H "$dir" -maxdepth 0 -type d -perm /$perm_mask)
    if [ "$find_result" != "" ]
    then
      # Update the directory permission

      expected_permission=$(printf 0%o $[0777 & ~0$perm_mask])
      chmod $expected_permission $dir
    fi
done <<EOF
$dirs
EOF
