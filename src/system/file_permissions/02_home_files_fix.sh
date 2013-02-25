#!/usr/bin/env bash

# Copied from 02_home_files.sh
passwd=/etc/passwd
useradd=/etc/default/useradd
default_homedir=/home

# files that should not be owned by someone other than the home directory owner, or readable
# even read permission can be dangerous for these files
NO_READ_NO_WRITE_FILES="\
    .netrc \
    .rhosts \
    .shosts \
    .Xauthority \
    .gnupg/secring.gpg \
    .pgp/secring.pgp \
    .ssh/identity \
    .ssh/id_dsa \
    .ssh/id_rsa \
    .ssh/random_seed \
    .pgp/randseed.bin"

# files that should not be owned by someone other than the home directory owner, or writeable
# write permission to these files is dangerous
NO_WRITE_FILES="\
    .bashrc \
    .bash_profile \
    .bash_login \
    .bash_logout \
    .cshrc \
    .emacs \
    .exrc \ 
    .forward \
    .gdbrc \
    .klogin \
    .login \ 
    .logout \
    .profile \
    .tcshrc \
    .fvwmrc \
    .inputrc \
    .kshrc \
    .nexrc \
    .screenrc \
    .ssh \
    .ssh/config \
    .ssh/authorized_keys \
    .ssh/environment \
    .ssh/known_hosts \
    .ssh/rc \
    .twmrc \
    .vimrc \
    .viminfo \
    .xsession \
    .xinitrc \
    .Xdefaults \
    .zshenv \
    .zprofile \
    .zshrc \
    .zlogin \
    .zlogout"

setperms()
{
  PERM=$1
  shift

  HOMEDIR=$1
  shift

  for i in $@;
  do
    FULLPATH=$HOMEDIR/$i
    [ "$i" != "\\" -a -f $FULLPATH ] && chmod $PERM $FULLPATH
  done
}

while read line
do
  HOMEDIR=$line

  setperms go-rwx $HOMEDIR $NO_READ_NO_WRITE_FILES
  setperms go-w $HOMEDIR $NO_WRITE_FILES
done <<EOF
`grep -v /sbin/nologin /etc/passwd | cut -d: -f 6`
EOF
