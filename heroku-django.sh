#!/bin/bash

#will change the name of the heroku app
change_herokuapp_name(){
	local project_name_untouched=$1
	local heroku_name="${project_name_untouched}-dev"
	read -p "Wanker boy, what's the name of your heroku app (enter for ${heroku_name})" answer
	if [ "$answer" != $"" ]
	then 
		heroku_name=$answer
	fi
	heroku apps:rename ${heroku_name}
}

#will install south, add what's necessary to the settings file and init south
install_south(){
	local project_name=$1
	project_name=`echo $project_name | tr "-" _`
	read -p "would you like to install south? (y/n)" answer
	case $answer in  
  		y|Y) 
	  		pip install South;
	  		echo "INSTALLED_APPS = INSTALLED_APPS + ('south',)" >> ${project_name}_app/settings.py
	  		python manage.py syncdb
	  		python manage.py schemamigration ${project_name}_app --initial
	  		python manage.py migrate ${project_name}_app
	esac
}
http://www.cyberciti.biz/faq/delete-directory-command-in-terminal/
#will install tastypie and add what's necessary to the settings file
install_tastypie() {
	local project_name=$1
	project_name=`echo $project_name | tr "-" _`
	read -p "would you like to install tastypie? (y/n)" answer
	case $answer in  
  		y|Y) 
	  		pip install django-tastypie;
	  		echo "INSTALLED_APPS = INSTALLED_APPS + ('tastypie',)" >> ${project_name}_app/settings.py
	  		python manage.py syncdb
			python manage.py migrate ${project_name}_app

	esac
}

# used to create django heroku project.
# the script will prompt for the kind of project and will install
# the necessary files for the project
# $1 project name
main(){
	if (( $# != 1 ))
	then
	  echo "Please supply project name (only)"
	  exit 1
	fi
	local project_name=$1
	local project_name_untouched=$1
	echo "Creating project folder bitch (${project_name})"
	mkdir ${project_name}
	cd ${project_name}
	project_name=`echo $project_name | tr "-" _`
	echo 'Creating the virtual enviroment bitch (venv)'
	virtualenv venv --distribute
	echo 'Activating the virtual enviroment bitch'
	source venv/bin/activate
	echo 'Installing django to the virtual enviroment'
	pip install Django
	read -p "Yo bitch, Care to install psycopg2?? (y/n)" answer
	case $answer in  
  		y|Y) pip install psycopg2; 
	esac
	read -p "Yo bitch, Care to install gunicorn?? (y/n)" answer
    	case $answer in  
	    	y|Y) pip install gunicorn; 
    	esac
	read -p "Yo bitch, Care to install dj-database-url?? (y/n)" answer_dj
    	case $answer_dj in  
            	y|Y) pip install dj-database-url; 
    	esac
	echo "Creating the django project (${project_name_app})"
	`django-admin.py startproject ${project_name}_app .`
	echo 'Yo asshole, gonna create the Procfile'
	touch Procfile
	echo 'web: python manage.py run_gunicorn -b "0.0.0.0:$PORT"' >> Procfile

	case $answer_dj in
                y|Y) 
			echo 'Appending extra configuration to the settings file'
        		echo -e '\n' >> ${project_name}_app/settings.py
        		echo  '# Parse database configuration from $DATABASE_URL' >> ${project_name}_app/settings.py
        		echo  'import dj_database_url' >> ${project_name}_app/settings.py
        		echo  "DATABASES['default'] =  dj_database_url.config()" >> ${project_name}_app/settings.py
        		echo -e '\n' >> ${project_name}_app/settings.py
        		echo "# Honor the 'X-Forwarded-Proto' header for request.is_secure()" >> ${project_name}_app/settings.py
        		echo "SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')" >> ${project_name}_app/settings.py
        esac
	echo 'Creating git ignore file'
	touch .gitignore
	echo 'venv' >> .gitignore
	echo '*.pyc' >> .gitignore
	echo 'Creating a new git repository'
	git init
	git add .
	git commit -m "init django app"
	echo 'Creating requirments file'
	pip freeze > requirments.txt
	
	echo 'creating heroku app'
	heroku create

	#Gal: Lesson2 - finish creation of local postgres database 
	read -p "Would you like to create a local database (y/n)" answer
	case $answer in  
            y|Y) 
				read -p "Please enter your postgres username:" postgres_username
				read -p "Please enter your postgres password:" postgres_password
				# create db named : {projectName}_db
				local postgres_database_name=${project_name}_db
       			        echo "CREATE DATABASE ${postgres_database_name};" | sudo -u postgres psql 
				# setting environment variable of DATABASE_URL
				echo setting environment variable of DATABASE_URL
				export DATABASE_URL=postgresql://${postgres_username}:${postgres_password}@localhost:5432/${postgres_database_name} 

			    	#Gal: Lesson2 - run sync db to create the tables in the local database
				python manage.py syncdb
    	esac
    	
    	#changing the name of the heroku app
    	change_herokuapp_name $project_name_untouched
    	
    	echo 'adding our app to the settings'
    	echo "INSTALLED_APPS = INSTALLED_APPS + ('${project_name}_app',)" >> ${project_name}_app/settings.py
    	
    	echo 'creating models file'
    	touch ${project_name}_app/models.py
    	
    	install_south $project_name_untouched
	install_tastypie $project_name_untouched
    

    	

    #Gal: Lesson2 - create enviroment varialbe in virtual env called DATABASE_URL



    #Gal: Lesson3 - would you like to add admin interface to you project?

    #Gal: Lesson3 - would you like to install south? + add south init

    #Gal: Lesson4 - would you like to install tastypie?

}

main $*

#install_south $*



