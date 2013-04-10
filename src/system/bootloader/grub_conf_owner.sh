#!/usr/bin/env sh

RET=$XCCDF_RESULT_PASS

if [ -e /boot/grub/grub.conf ]
then
  OWNER=$(stat -c '%U' /boot/grub/grub.conf)

  if [ $OWNER != 'root' ]
  then
    echo "/boot/grub/grub.conf should be owned by root instead or $OWNER"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

if [ -e /boot/grub2/grub.cfg ]
then
  OWNER=$(stat -c '%U' /boot/grub2/grub.cfg)

  if [ $OWNER != 'root' ]
  then
    echo "/boot/grub2/grub.cfg should be owned by root instead of $OWNER"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

exit $RET
