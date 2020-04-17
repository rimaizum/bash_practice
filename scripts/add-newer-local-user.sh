#!/bin/bash


# Verify that the user running the script is either the root user or a user with elevated priviledges.
EXPECTED_USER=root

if [[ $(whoami) != $EXPECTED_USER ]]
then
	echo "Please run this script either as the root user or a user with root priviledges." >&2
	exit 1
fi 

# Verify that there is at least one provided argument for the script.

if [[ ${#} -lt 1 ]]
then
	echo "Usage: $(basename ${0}) [USERNAME] [COMMENTS]... " >&2
	echo "Please provide the username at a minimum." ≥&2
        exit 1
fi

# Use the first argument provided by the user as the username for the new user.
# Shift and use any other arguments as a string for the comments parameter

USERNAME=${1}
shift
COMMENTS=${@}
#generate a new password for the user 
PASSWORD=$(date +%s%N | sha256sum | head -c20)
useradd -m -c "${COMMENTS}" ${USERNAME} &> /dev/null

# Error checking to verify username was able to be creaated successfully.
if [[ "${?}" != 0 ]]
then
	echo "The user was unable to be created successfully" >&2
	exit 1
fi

# Apply the password to the newly created user account

echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

if [[ "${?}" != 0 ]]
then
	echo "The password was unable to be created successfully" >&2
	exit 1
fi

# Change password on first login.

passwd -e ${USERNAME} &> /dev/null

# Display the username / password / host for the user

echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"




