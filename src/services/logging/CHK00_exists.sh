SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/common.sh

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
  if [ ! -e $name ]
  then
    echo "File $name does not exist"
    RET=$XCCDF_RESULT_FAIL
  fi

  if [ ! -f $name ]
  then
    echo "File $name not a regular file"
    RET=$XCCDF_RESULT_FAIL
  fi
done

exit $RET
