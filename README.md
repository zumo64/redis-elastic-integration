# Objective
POC using the Elastic Stack to parse and visualise redis Enterprise logs.
The following logs are currently ingested :
* Audit logs
* more to come

# Setup Containers

```
# start the containers - first time it will take a few minutes to setup the env 
# Wait until the setup container terminates

docker-compose up

``` 

When the RE container is started up you can start setting up Redis and enable the audit logs. Check next section.



# Setup a RE cluster

Setup Redis Enterprise with audit logs. 
That can be done manually using the rladmin commands or executing the script in  ./test/setup.sh.

In a shell terminal (in the redis container)  run the commands located in the script `./test/setup.sh`  

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
rladmin status

# Generate connections (random duration) to the 2 databases created above
./setup.sh --run-connect 1 50 &
./setup.sh --run-connect 2 50 &


````

Note1: Sometimes the REST commands report a connection failure to `localhost` In that case, try again a few times and usually it will work..    use the container IP address otherwise.

Note2: the random number generation (for random connection times) doesn't work as well as expected  TODO fix it

# Connections Dashboard

Give the connections events  5-10 minutes run, then open Kibana Dashboard `Redis Connection Status` 

After selecting an appropriate time range, you can :

* Select the database metrics , or include all databases
* Display connections still open or only the closed connections by toggling the filter `Connections Closed` Include/Exclude results
* Select a source IP addess in the Tag Cloud of external source IPs connected (during the time range)
* See the Authorized/ Not Authorized authentications per database
* View an histogram of the connection durations and select a time range  

ALl the internal connections are filtered out 


Coming soon : 
* Additional Logs including Slow logs
* Alerts

![Dashboard Screenshot](https://github.com/zumo64/redis-elastic-integration/blob/main/dashboard.png)



