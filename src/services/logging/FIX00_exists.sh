SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/common.sh

while name owner group perm
do
  if [ ! -e $name -o ! -f $name ]
  then
    rm -rf $name

    touch $name
    chown $owner $name
    chgrp $group $name
    chmod $perm $name
  fi
done
