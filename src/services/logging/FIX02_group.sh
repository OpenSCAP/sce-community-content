SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/common.sh

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
  chgrp $group $name
done
