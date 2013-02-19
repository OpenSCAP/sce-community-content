SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/08_permissions.sh CONSTANTS

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
