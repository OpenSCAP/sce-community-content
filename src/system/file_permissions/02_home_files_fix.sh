SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/02_home_files.sh CONSTANTS

setperms()
{
  PERM=$1
  shift

  HOMEDIR=$1
  shift

  for i in $@;
  do
    FULLPATH=$HOMEDIR/$i
    [ "$i" != "\\" -a -f $FULLPATH ] && chmod $PERM $FULLPATH
  done
}

while read line
do
  HOMEDIR=$line

  setperms go-rwx $HOMEDIR $NO_READ_NO_WRITE_FILES
  setperms go-w $HOMEDIR $NO_WRITE_FILES
done <<EOF
`grep -v /sbin/nologin /etc/passwd | cut -d: -f 6`
EOF
