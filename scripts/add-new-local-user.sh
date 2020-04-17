#!/bin/bash

# This script creates a new user on the local system. 
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an arguement.
# A password will be automcatically generated for the account.
# The username, password and host for the account will be displayed.

# If then statement enforcing that the user executing this script either is root or has super user priviledges, returning an exit 1 code if it does not
EXPECTED_USER=root
if [[ $(id -nu) != ${EXPECTED_USER}  ]]
then
	echo "You need to execute this script as ${EXPECTED_USER} or with superuser priviledges"
	exit 1
fi

# Verifies that the user executing the script provided at least one arguement along with the script, providing instructions on what to do and exiting if they ddid not.

#NUM_PARAMETERS=${#}
if [[ "${#}" -lt 1  ]] 
then
	echo "Usage: $(basename ${0}) [USERNAME] [COMMENTS]..."
	exit 1
fi


# Use the first argument provided by the user as the username for the account. Any remaining arguments will be added as a comment for the account.
USERNAME=${1}
shift
while [[ ${#} -gt 0 ]]
do
	STRING+="${1} "
	shift
done
echo $STRING

# String="${@}"
# ^Alternative to what i did above.


# Automatically generate a password for the new account.

# Uses the date command with the epoch time / nano second flag which is passed through sha256sum and then edited down to the first 20 characters.
PASSWORD=$(date +%s%N | sha256sum | head -c20)

# Create the user with the arguments inputted in the string
useradd -m -c "${STRING}" ${USERNAME}


# Check to verify if the user was able to be created successfully if not exit with a exit 1 status.
if [[ "${?}" != 0  ]]
then
	echo "The user: ${USERNAME} was not able to be created successfully."
	exit 1
fi

# Add the password generated above for the user

echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Check if the password was set correctly

if [[ "${?}" -ne 0  ]]
then
	echo 'The password for the account could not be set.'
	exit 1
fi

# Have the user change the password on next login.
passwd -e ${USERNAME}
# Display the Username / Password / Host where the account was created.

echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Host: $HOSTNAME"
exit 0
