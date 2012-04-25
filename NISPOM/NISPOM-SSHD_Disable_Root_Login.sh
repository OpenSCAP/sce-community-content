#!/usr/bin/env sh

###########################AQUEDUCT##################################
#By Tummy a.k.a Vincent C. Passaro				     #
#Vincent[.]Passaro[@]fotisnetworks[.]com			     #
#www.vincentpassaro.com						     #
###########################AQUEDUCT##################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Vincent C. Passaro | 17-DEC-2011|
#|	    |   Creation	    |                    |            |
#|__________|_______________________|____________________|____________|
#######################NISPOM INFORMATION##############################
# CAT 
# Description : 
#######################NISPOM INFORMATION##############################

# Reworked by Martin Preisler <mpreisle@redhat.com> for use with XCCDF and SCE

if [[ $UID -ne '0' ]]
then
    echo 'You have to be logged as root to run this test!'
    exit ${XCCDF_RESULT_ERROR}
fi

# we are looking for 'permitrootlogin yes'
if /usr/sbin/sshd -T | grep -q 'permitrootlogin yes'; then
    echo 'Root login is permitted in sshd configuration!'
    exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS
