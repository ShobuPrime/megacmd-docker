#!/bin/bash

# Attempting to use docker environment variables
echo "Setting PID and GID environmental variables"
./fix_permissions.sh

#echo "Starting MegaCMD Server"
#mega-cmd-server --debug --skip-lock-check &>/dev/null &

su -c mega-version ${USER}
existing_session=/home/${USER}/.megaCmd/session
if [ -f  "$existing_session" ]; then
    echo "Session file found, who am I?"
    su -c 'mega-whoami' ${USER}
    echo "------------------------------------------------------------------------------"
    echo "What sync tasks what I running?"
    su -c 'mega-sync' ${USER}
else 
    echo "No detected session. Logging in as:"
    su -c 'mega-login ${SESSION_ID}' ${USER}
    su -c 'mega-whoami' ${USER}
    echo "------------------------------------------------------------------------------"
    su -c 'mega-https on' ${USER}
    echo "------------------------------------------------------------------------------"
    su -c 'mega-https' ${USER}
    echo "------------------------------------------------------------------------------"
    su -c 'mega-sync /home/${USER}/Mega /' ${USER}
fi

# Cheap and dirty way to keep container running

#https://phpfog.com/how-to-keep-docker-containers-running/#:~:text=If%20you%20would%20like%20to%20keep%20your%20container,a%20custom%20script%20used%20with%20CMD%20or%20ENTRYPOINT.
tail -f /dev/null
