#!/bin/bash

# this script will create a new postgres user
# $1 postgres_username
# $2 postgres_password

main() {
	if (( $# != 2 ))
	then
	  echo "Please supply postgres username and password (only)"
	  exit 1
	fi
	local postgres_username=$1
	local postgres_password=$2
	echo "Creating postgres user ${postgres_username}"
	echo "CREATE USER ${postgres_username} WITH PASSWORD '${postgres_password}';" | sudo -u postgres psql 
	# add createdb permission to this user, necessary for allowing creating test database (TDD).
	echo "ALTER USER ${postgres_username} CREATEDB;" | sudo -u postgres psql 
}

main $*
