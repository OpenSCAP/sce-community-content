#!/usr/bin/env sh

RET=$XCCDF_RESULT_PASS

if [ -e /boot/grub/grub.conf ]
then
  ACCESS=$(stat -c '0%a' /boot/grub/grub.conf)

  if [ $ACCESS -ne 0600 ]
  then
    echo "/boot/grub/grub.conf should have its permissions set to 0600 instead of 0$ACCESS"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

if [ -e /boot/grub2/grub.cfg ]
then
  ACCESS=$(stat -c '0%a' /boot/grub2/grub.cfg)

  if [ $ACCESS -ne 0600 ]
  then
    echo "/boot/grub2/grub.cfg should have its permissions set to 0600 instead of 0$ACCESS"
    RET=$XCCDF_RESULT_FAIL
  fi
fi

exit $RET
