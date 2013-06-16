#!/bin/bash

#this script will install applications needed for our apps in ubuntu
main{}{
	#install git
	sudo apt-get install git

	#install prerequisites for aptana
	sudo apt-get install openjdk-7-jdk libjpeg62 libwebkitgtk-1.0-0 git-core

	#install virtualenv
	sudo apt-get install python-virtualenv

	#install heroku toolbelt
	wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

	#install postgresql 9.1
	sudo apt-get install postgresql-9.1
	sudo apt-get install postgresql-client-9.1
	sudo apt-get install postgresql-contrib-9.1
	sudo apt-get install libpq-dev
	sudo apt-get install postgresql-server-dev-9.1
	sudo apt-get install pgadmin3

	#install python-dev
	sudo apt-get install python-dev

	#install build-essential
	sudo apt-get install build-essential
	
	
}

main $*
