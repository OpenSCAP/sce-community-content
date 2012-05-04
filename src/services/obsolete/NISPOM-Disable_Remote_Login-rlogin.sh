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

# Modified by Martin Preisler <mpreisle@redhat.com> for use with XCCDF and SCE

if [ -a /etc/pam.d/rlogin ]; then
    echo "rlogin is installed!"
    exit $XCCDF_RESULT_FAIL
fi

exit $XCCDF_RESULT_PASS

