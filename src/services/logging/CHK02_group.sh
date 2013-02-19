SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/common.sh

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
  find / \( -path $name -a ! -group $group \) -print "Invalid group for %p"
done

exit $RET
