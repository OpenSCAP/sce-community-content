RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ "x$(find $home/.ssh -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.ssh has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.ssh)" != "x$user" ]
    then
        echo "$home/.ssh has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.ssh/authorized_keys -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.ssh/authorized_keys has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.ssh/authorized_keys)" != "x$user" ]
    then
        echo "$home/.ssh/authorized_keys has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.ssh/environment -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.ssh/environment has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.ssh/environment)" != "x$user" ]
    then
        echo "$home/.ssh/environment has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.ssh/known_hosts -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.ssh/known_hosts has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.ssh/known_hosts)" != "x$user" ]
    then
        echo "$home/.ssh/known_hosts has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.ssh/rc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.ssh/rc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.ssh/rc)" != "x$user" ]
    then
        echo "$home/.ssh/rc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7)
EOF

exit $RET
