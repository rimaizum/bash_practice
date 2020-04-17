#!/bin/bash

# Enforces that script is executed with superuser (root) priviledges.

USERCHECK='root'
USERNAME=$(id -un)
if [[ "${USERNAME}" != ${USERCHECK}  ]]
then
	echo "This script needs to be executed as the ${USERCHECK} user"
	exit 1
fi

# Ask user for username
read -p "What is the username of the user: " USERNAME

# Ask user for comment / Real name
read -p "What is the user's real name: " COMMENT

# Ask user for password 
read -p "What is the password for the user: " PASSWORD

# Create user based on the above info
useradd -c "${COMMENT}" ${USERNAME}

# error checking to see if user could be created
if [[ "${?}" != 0  ]]
then 
	echo "The user was unable to be created"
	exit 1
fi


#Add password for the user
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Force password change on first login.

passwd -e ${USERNAME}

#Display username / password / real name / hostname
echo
echo 'username:'
echo "${USERNAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
