#!/bin/sh

# Check if PermitEmptyPasswords is enabled (commented lines will be replaced too)
if grep -q PermitEmptyPasswords /etc/ssh/sshd_config
then
  sed -i 's|^.*PermitEmptyPasswords.*$|PermitEmptyPasswords no|ig' /etc/ssh/sshd_config
else
  echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
fi
