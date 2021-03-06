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
  		y|Y) 
		pip install psycopg2; 
	esac
	read -p "Yo bitch, Care to install gunicorn?? (y/n)" answer
    	case $answer in  
	    	y|Y) 
		pip install gunicorn; 
		echo "INSTALLED_APPS = INSTALLED_APPS + ('gunicron',)" >> ${project_name}_app/settings.py
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
	echo 'creating heroku app'
	heroku create

	# creation of local postgres database 
	read -p "Would you like to create a local database (y/n)" answer
	case $answer in  
    		y|Y) 
		read -p "Please enter your postgres username:" postgres_username
		read -p "Please enter your postgres password:" postgres_password
		# create db named : {projectName}_db
		local postgres_database_name=${project_name}_db
	        echo "CREATE DATABASE ${postgres_database_name};" | sudo -u postgres psql 
		# setting environment variable of DATABASE_URL
		echo 'setting environment variable of DATABASE_URL'
		export DATABASE_URL=postgresql://${postgres_username}:${postgres_password}@localhost:5432/${postgres_database_name} 

	    	# run sync db to create the tables in the local database
		echo 'syncing local database inorder to create the tables'
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
      
	# add static and templates directories to the project app directory
	mkdir ${project_name}_app/static
	mkdir ${project_name}_app/templates
	echo "import os.path" >> ${project_name}_app/settings.py
	echo "TEMPLATE_DIRS = TEMPLATE_DIRS + (os.path.join(os.path.dirname(__file__), 'templates').replace('\\','/'),)" >> ${project_name}_app/settings.py


	# create fixtures directory (used for TDD)
	read -p "Would you like to create a fixtures directory (used for TDD) (y/n)" answer
	case $answer in  
    		y|Y) 
		mkdir ${project_name}_app/fixtures
		touch ${project_name}_app/fixtures/${project_name}_app.json
    	esac

	# add admin interface to project
	read -p "Would you like to create add admin interface to your project (y/n)" answer
	case $answer in  
    		y|Y) 

		# editing the settings.py file
	    	echo "INSTALLED_APPS = INSTALLED_APPS + ('django.contrib.admin','django.contrib.auth','django.contrib.contenttypes','django.contrib.sessions','django.contrib.messages','django.contrib.staticfiles',)" >> ${project_name}_app/settings.py

	    	echo "MIDDLEWARE_CLASSES = MIDDLEWARE_CLASSES + ('django.middleware.common.CommonMiddleware','django.contrib.sessions.middleware.SessionMiddleware','django.contrib.auth.middleware.AuthenticationMiddleware','django.contrib.messages.middleware.MessageMiddleware',)" >> ${project_name}_app/settings.py

		# add the admin tables to our database
		python manage.py syncdb
		
		# editing the urls.py file
		echo "from django.contrib import admin" >> ${project_name}_app/urls.py
		echo "admin.autodiscover()" >> ${project_name}_app/urls.py
		echo "urlpatterns = urlpatterns + ((r'^admin/', include(admin.site.urls)),)" >> ${project_name}_app/urls.py
    	esac

	# finally we create the requirments file
	echo 'Creating requirments file'
	pip freeze > requirments.txt
}

main $*




