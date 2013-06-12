#!/bin/bash

# this script will create a new postgres user
# $1 postgres_username
# $2 postgres_password

main() {
	local postgres_username=$1
	local postgres_password=$2
	echo "Creating postgres user ${postgres_username}"
	echo "CREATE USER ${postgres_username} WITH PASSWORD '${postgres_password}';" | sudo -u postgres psql 
}

main $*
