#!/bin/sh

get_export_count()
{
  sed -e 's,#.*$,,' < $1 | grep -v '^\s*$' | wc -l
}

RET=$XCCDF_RESULT_PASS

while read file
do
  [ "x$file" = "x" ] && continue

  EXPORT_COUNT=$(get_export_count $file)
  if [ $EXPORT_COUNT -ne 0 ]
  then
    echo "NFS exports found in file $file"
    RET=$XCCDF_RESULT_FAIL
  fi

done <<_EOF
/etc/exports
$(find /etc/exports.d -type f)
_EOF

exit $RET
