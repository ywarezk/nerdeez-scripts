#nerdeez-scripts


common bash scripts
make sure you chmod the scripts to be executables

```sudo chmod +x {NAME_OF_SCRIPT}```

## killport

will check if port number has a program that holds the port busy
if program exists will kill it to free the port.
usefull when we runserver on eclipse somtime the port is not freed

#### Usage

```./killport {#PORT_NUMBER}```


## create_postgres_user

create a new user for postgres login information

#### Usage

```./create_postgres_user {USERNAME} {PASSWORD}```

## install-compass

install compass using ruby and rubygems

#### Usage

```./install-compass ```


## oreder of scripts to run

1. install-prerequisites.sh (run only once)
2. create_postgres_user.sh (run only once)
3. heroku-django.sh (run for every new project)
