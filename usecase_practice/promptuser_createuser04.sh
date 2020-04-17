#!/bin/bash

# This script creates an account on the local system.
# You will be prompted for the account name and password

# Ask for the user name.
read -p 'Enter the username to create: ' USERNAME

# Ask for the real name.
read -p 'Enter the name of the person who this account is for: ' COMMENT

# Ask for the password.
read -p 'Enter the password to use for the account: ' PASSWORD

# Create the user.
useradd  -c "${COMMENT}" -m ${USERNAME}


# Set the password for the user.
echo ${PASSWORD} | passwd  --stdin  ${USERNAME}


# Force password change on first login.

passwd -e ${USERNAME}


if [[ ${?} != 0  ]]
then
	echo "The user was unable to be created successfully" 
	exit 1
