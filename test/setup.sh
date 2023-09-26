#!/bin/bash
NUMBER_DATABASES=2
PORTS=( "10670" "10671")



# Loop through all command line arguments
for arg in "$@"; do
  
  if [ "$arg" == "--cluster" ]; then
    # Perform the action when --create is found
    rladmin cluster create name cluster.local username redis@redis.com password redis
    sleep 5
    rladmin cluster config auditing db_conns audit_protocol TCP audit_address esagent audit_port 8500
    rladmin tune cluster db_conns_auditing enabled

  fi


  if [ "$arg" == "--db" ]; then
    echo "Creating the databases ..."
    # create 2 DB
	curl -X POST -H 'cache-control: no-cache' -H 'Content-type: application/json' -u redis@redis.com:redis --retry 20  --retry-connrefused -d '{ "bdb": {"uid":1,"name": "zumo-test-db1","type": "redis","memory_size": 1000000,"shards_count":1, "authentication_redis_pass":"redis", "port" : 10670 }}' -k https://localhost:9443/v2/bdbs
	sleep 5
	rladmin tune db db:1 db_conns_auditing enabled
	sleep 5
	curl -X POST -H 'cache-control: no-cache' -H 'Content-type: application/json' -u redis@redis.com:redis --retry 20 --retry-connrefused -d '{ "bdb": {"uid":2,"name": "zumo-test-db2","type": "redis","memory_size": 1000000,"shards_count":1, "authentication_redis_pass":"redis", "port" : 10671 }}' -k https://localhost:9443/v2/bdbs
	sleep 5 
	rladmin tune db db:2 db_conns_auditing enabled
  fi


  # ./setup.sh --connect <dbuid> <nb repeat> 
  if [ "$arg" == "--connect" ]; then
    echo "testing connecton ..."
    delay=$(( $RANDOM % 20 + 1 ))
    db=$2
    dbport="${PORTS[db-1]}"
    for value in $(seq 1 "$3") ; do
    	echo "connecting to database $db  port $dbport for $delay seconds"
    	redis-cli -h localhost -p $dbport -a redis --intrinsic-latency $delay
    done
  fi



  


  if [ "$arg" == "--del" ]; then
    echo "Deleting  databases ..."
	curl  -X DELETE -H 'cache-control: no-cache' -H 'Content-type: application/json' --retry 5  --retry-connrefused -u redis@redis.com:redis -k  https://localhost:9443/v1/bdbs/1
	sleep 5
	curl  -X DELETE -H 'cache-control: no-cache' -H 'Content-type: application/json' --retry 5  --retry-connrefused -u redis@redis.com:redis -k  https://localhost:9443/v1/bdbs/2
  fi







done
