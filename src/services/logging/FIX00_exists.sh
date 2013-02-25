#!/usr/bin/env bash

LOGFILES="/var/log/wtmp root utmp 664
	  /var/log/btmp root utmp 600
	  /var/log/lastlog root root 644
	  /var/run/utmp root utmp 664
	  /var/log/messages root root 600"

while name owner group perm
do
  if [ ! -e $name -o ! -f $name ]
  then
    rm -rf $name

    touch $name
    chown $owner $name
    chgrp $group $name
    chmod $perm $name
  fi
done
