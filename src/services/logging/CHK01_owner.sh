SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/common.sh

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
  find / \( -path $name -a ! -owner $owner \) -print "Invalid owner for %p"
done

exit $RET
