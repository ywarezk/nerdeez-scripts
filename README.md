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

