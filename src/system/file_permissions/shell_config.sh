RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ "x$(find $home/.bashrc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.bashrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.bashrc)" != "x$user" ]
    then
        echo "$home/.bashrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.bash_profile -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.bash_profile has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.bash_profile)" != "x$user" ]
    then
        echo "$home/.bash_profile has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.bash_login -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.bash_login has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.bash_login)" != "x$user" ]
    then
        echo "$home/.bash_login has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.bash_logout -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.bash_logout has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.bash_logout)" != "x$user" ]
    then
        echo "$home/.bash_logout has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.klogin -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.klogin has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.klogin)" != "x$user" ]
    then
        echo "$home/.klogin has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.login -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.login has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.login)" != "x$user" ]
    then
        echo "$home/.login has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.logout -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.logout has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.logout)" != "x$user" ]
    then
        echo "$home/.logout has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.profile -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.profile has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.profile)" != "x$user" ]
    then
        echo "$home/.profile has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.tcshrc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.tcshrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.tcshrc)" != "x$user" ]
    then
        echo "$home/.tcshrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.cshrc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.cshrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.cshrc)" != "x$user" ]
    then
        echo "$home/.cshrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.kshrc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.kshrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.kshrc)" != "x$user" ]
    then
        echo "$home/.kshrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.zshenv -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.zshenv has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.zshenv)" != "x$user" ]
    then
        echo "$home/.zshenv has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(find $home/.zshrc -perm /022 -maxdepth 0)" != "x" ]
    then
        echo "$home/.zshrc has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.zshrc)" != "x$user" ]
    then
        echo "$home/.zshrc has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7)
EOF

exit $RET
