#!/usr/bin/env bash

LOGFILES="/var/log/wtmp root utmp 664
    /var/log/btmp root utmp 600
    /var/log/lastlog root root 644
    /var/run/utmp root utmp 664
    /var/log/messages root root 600"

RET=$XCCDF_RESULT_PASS

while name owner group perm
do
  find / \( -path $name -a ! -owner $owner \) -print "Invalid owner for %p"
done

exit $RET
