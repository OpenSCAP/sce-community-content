RET=$XCCDF_RESULT_PASS

while read user home shell
do
    if [ "x$shell" == "x/sbin/nologin" ]
    then
        continue
    fi
    if [ "x$(find $home/.gnupg/secring.gpg -perm /077 -maxdepth 0)" != "x" ]
    then
        echo "$home/.gnupg/secring.gpg has invalid permissions set"
        RET=$XCCDF_RESULT_FAIL
    fi

    if [ "x$(stat -c '%U' $home/.gnupg/secring.gpg)" != "x$user" ]
    then
        echo "$home/.gnupg/secring.gpg has invalid owner"
        RET=$XCCDF_RESULT_FAIL
    fi

done <<EOF
$(cat /etc/passwd | cut -d ':' -f 1,6,7)
EOF

exit $RET
