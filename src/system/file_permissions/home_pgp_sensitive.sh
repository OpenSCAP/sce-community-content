#!/bin/sh

RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ -e $home/.pgp/randseed.bin ]
    then
        if [ "x$(find $home/.pgp/randseed.bin -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.pgp/randseed.bin has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.pgp/randseed.bin)" != "x$user" ]
        then
            echo "$home/.pgp/randseed.bin has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

    if [ -e $home/.pgp/secring.pgp ]
    then
        if [ "x$(find $home/.pgp/secring.pgp -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.pgp/secring.pgp has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.pgp/secring.pgp)" != "x$user" ]
        then
            echo "$home/.pgp/secring.pgp has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7 | tr ':' ' ')
EOF

exit $RET
