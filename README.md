
# Setup Containers

```
# start the containers - first time it will take a few minutes to setup the env 
# Wait until the setup container terminates

docker-compose up

``` 

When the RE container is started up you can start set up Redis and enable the audit logs. Check next section.



# Setup RE cluster

Setup Redis Enterprise with audit logs. 
That can be done manually using the rladmin commands or executing the script in  ./test/setup.sh.

The commands are located in `./test/setup.sh`  

On a shell terminal (in the redis container)  do the follwing:  

```
# inside the re1 container use the following commands to:
# 1. create a 1 node cluster and enable audit logs
# 2. create 2 databases 
# run a test that connects to boths  databases randomly so we can see events in Kibana 

cd /tmp
# Create a 1 node cluster and enable audit logs
./setup.sh --create-cluster

# create 2 databases for testing
./setup.sh --create-db

# check every thing is OK
rladlmin status

# Generate connections (random duration) to the 2 databases created above
./setup.sh --run-connect 1 50 &
./setup.sh --run-connect 2 50 &


````

Note1: Sometimes the REST commands report a connection failure to `localhost` In that case, try again a few times and usually it worls..   use the container IP address otherwise.
Note2: the random number generation doesn't work as well as expected 

# Visualize dashboard

Give it a few minutes (5 minutes) to let the transform kick in and aggregate enough metrics then open Kibana Dashboard `Redis Connection Status`

You can use the following things :

* Select a time range
* Select which database you want to audit , or all databases
* Filter connetions still open or only the closed connections
* You will see a Tag Cloud of external source IPs 
* See the Authorized/ Not Authorized authentications per database

ALl the internal connections are filtered out 


Coming soon : more logs and some alerts



