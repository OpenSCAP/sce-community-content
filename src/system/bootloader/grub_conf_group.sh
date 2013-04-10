#!/usr/bin/env sh

RET=$XCCDF_RESULT_PASS

if [ -e /boot/grub/grub.conf ]
then
  GROUP=$(stat -c '%G' /boot/grub/grub.conf)

  if [ $GROUP != 'root' ]
  then
    echo "/boot/grub/grub.conf should be group-owned by root instead or $GROUP"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

if [ -e /boot/grub2/grub.cfg ]
then
  GROUP=$(stat -c '%G' /boot/grub2/grub.cfg)

  if [ $GROUP != 'root' ]
  then
    echo "/boot/grub2/grub.cfg should be group-owned by root instead of $GROUP"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

exit $RET
