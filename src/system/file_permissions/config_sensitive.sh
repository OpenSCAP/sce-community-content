RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ "x$(find $home/.netrc -perm /077 -maxdepth 0)" != "x" ]
    then
        echo "$home/.netrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.netrc)" != "x$user" ]
    then
        echo "$home/.netrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.rhosts -perm /077 -maxdepth 0)" != "x" ]
    then
        echo "$home/.rhosts has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.rhosts)" != "x$user" ]
    then
        echo "$home/.rhosts has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.shosts -perm /077 -maxdepth 0)" != "x" ]
    then
        echo "$home/.shosts has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.shosts)" != "x$user" ]
    then
        echo "$home/.shosts has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.Xauthority -perm /077 -maxdepth 0)" != "x" ]
    then
        echo "$home/.Xauthority has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.Xauthority)" != "x$user" ]
    then
        echo "$home/.Xauthority has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7)
EOF

exit $RET
