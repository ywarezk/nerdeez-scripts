#!/bin/bash

#this script will install applications needed for our apps in ubuntu

install_yeoman(){
# Install Yeoman and all its dependencies in Ubuntu (64-bit)
# For 32-bit, you’ll need to download a different version of PhantomJS (I’m pretty sure everything else works the same).
# reference: http://ericterpstra.com/2012/10/install-yeoman-and-all-its-dependencies-in-ubuntu-linux/

	#install NodeJS
	sudo apt-get install python-software-properties
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install nodejs

	#install RVM + Ruby 1.9.3
	sudo apt-get install build-essential
	curl -L get.rvm.io | bash -s stable
	echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
	. ~/.bashrc
	sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
	rvm install 1.9.3
	rvm use 1.9.3 
	rvm --default use 1.9.3-p194
	ruby -v

	#install PhantomJS
	# (For 32-bit, just remove ‘_64′ from each command).
	cd ~/
	wget http://phantomjs.googlecode.com/files/phantomjs-1.7.0-linux-x86_64.tar.bz2
	tar -xvf 
	cd /usr/local/share
	sudo tar xvf ~/phantomjs-1.7.0-linux-x86_64.tar.bz2
	sudo ln -s /usr/local/share/phantomjs-1.7.0-linux-x86_64/ /usr/local/share/phantomjs
	sudo ln -s /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
	phantomjs --version
	rm ~/phantomjs-1.7.0-linux-x86_64.tar.bz2

	#install JPEGTRAN / OptiPNG
	sudo apt-get install libjpeg-turbo-progs
	sudo apt-get install optipng

	#install YEOMAN (finally!)
	sudo npm install -g yo grunt-cli bower
}

main(){
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

	#install compass
	sudo gem update --system
	sudo gem install compass

	#install curl
	sudo apt-get install curl

	#install Yeoman	
	install_yeoman
}

main $*
