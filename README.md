
# Setup Containers

```
# start the containers - first time it will take a few minutes to setup the env 
# Wait until the setup container terminates

docker-compose up

``` 

# Create API KEY for the elastic agent

login to Kibana https://localhost:5601/ using elastic/password credentials, go to Stack Management and follow instruction on this (page)[https://www.elastic.co/guide/en/fleet/8.9/grant-access-to-elasticsearch.html#create-api-key-standalone-agent]
to create an API key for the Elatic agent connect to Elasticsearch.

create the Key called "my-agent-key" with the create API Key Kibana oprion in Stack Management

Paste the API key (Beat Format) in place of the previous one in config/elastic-agent.yml
Restart the esagent container so it uses that key:

```
# stop and remove esagent 
docker-compose down esagent

# refresh with new API key value
docker-compose pull esagent 

# start esagent container
docker-compose up esagent -d
```




# Setup RE cluster and Database

Setup Redis Enterprise with audit logs. The commands are located in ./test/setup.sh. 
On a terminal on the redis container do the follwing:  

```
# inside the re1 container use the following commands to:
# 1. create a 1 node cluster and enable audit logs
# 2. create 2 databases 
# run a test that connects to boths  databases randomly so we can see events in Kibana 

cd /tmp
./setup.sh --create-cluster
./setup.sh --create-db

# check every thing is OK
rladlmin status

# Generate connections to the 2 databases created above
./setup.sh --run-connect 1 50 &
./setup.sh --run-connect 2 50 &


````


# Visualize dashboard

Give it a few minutes (5 minutes) to let the transform kick in and aggregate enough metrics then open Kibana Dashboard "Redis Connection Status"

You can use the following things :

* Select a time range
* Select which database you want to audit , or all databases
* Filter connetions still open or only the closed connections
* You will see a Tag Cloud of external source IPs 
* See the Authorized/ Not Authorized authentications per database

ALl the internal connections are filtered out 


Coming soon : more logs and some alerts



