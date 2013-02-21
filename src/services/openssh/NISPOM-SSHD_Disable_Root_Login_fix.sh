#!/bin/sh

# Check if PermitRootLogin is enabled (commented lines will be replaced too)
if grep -q PermitRootLogin /etc/ssh/sshd_config
then
  sed -i 's|^.*PermitRootLogin.*$|PermitRootLogin no|ig' /etc/ssh/sshd_config
fi
