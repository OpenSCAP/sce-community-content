#!/bin/sh

RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ -e $home/.ssh/identity ]
    then
        if [ "x$(find $home/.ssh/identity -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.ssh/identity has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.ssh/identity)" != "x$user" ]
        then
            echo "$home/.ssh/identity has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

    if [ -e $home/.ssh/id_rsa ]
    then
        if [ "x$(find $home/.ssh/id_rsa -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.ssh/id_rsa has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.ssh/id_rsa)" != "x$user" ]
        then
            echo "$home/.ssh/id_rsa has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

    if [ -e $home/.ssh/id_dsa ]
    then
        if [ "x$(find $home/.ssh/id_dsa -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.ssh/id_dsa has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.ssh/id_dsa)" != "x$user" ]
        then
            echo "$home/.ssh/id_dsa has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

    if [ -e $home/.ssh/config ]
    then
        if [ "x$(find $home/.ssh/config -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.ssh/config has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.ssh/config)" != "x$user" ]
        then
            echo "$home/.ssh/config has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

    if [ -e $home/.ssh/random_seed ]
    then
        if [ "x$(find $home/.ssh/random_seed -perm /077 -maxdepth 0)" != "x" ]
        then
            echo "$home/.ssh/random_seed has invalid permissions set"
            RET=$XCCDF_RESULT_FAIL
        fi

        if [ "x$(stat -c '%U' $home/.ssh/random_seed)" != "x$user" ]
        then
            echo "$home/.ssh/random_seed has invalid owner"
            RET=$XCCDF_RESULT_FAIL
        fi
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7 | tr ':' ' ')
EOF

exit $RET
