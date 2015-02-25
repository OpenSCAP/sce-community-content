#!/usr/bin/env sh

RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi

    if [ -e $home/.k5login ]
    then
        if [ "x$(find $home/.k5login -perm /055 -maxdepth 0)" != "x" ]
        then
            echo "$home/.k5login has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.k5login)" != "x$user" ]
        then
            echo "$home/.k5login has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7 | tr ':' ' ')
EOF

exit $RET

