
# Setup Containers

```

docker-compose up


``` 

# Create API KEY for the elastic agent
https://www.elastic.co/guide/en/fleet/8.9/grant-access-to-elasticsearch.html#create-api-key-standalone-agent


Create a TCP Log integration
listen 0.0.0.0
port 8500


create a Stand alone Elastic Agent with 






# Setup RE cluster and Database

```
# inside the container
rladmin cluster create name cluster.local username redis@redis.com password redis


# create a DB
curl -X POST -H 'cache-control: no-cache' -H 'Content-type: application/json' -u redis@redis.com:redis -d '{ "bdb": {"name": "zumo-test-db1","type": "redis","memory_size": 1000000,"shards_count":1, "authentication_redis_pass":"redis", "port" : 10670 }}' -k https://localhost:9443/v2/bdbs

curl -X POST -H 'cache-control: no-cache' -H 'Content-type: application/json' -u redis@redis.com:redis -d '{ "bdb": {"name": "zumo-test-db2","type": "redis","memory_size": 1000000,"shards_count":1, "authentication_redis_pass":"redis", "port" : 10671 }}' -k https://localhost:9443/v2/bdbs

rladmin cluster config auditing db_conns audit_protocol TCP audit_address esagent audit_port 8500
rladmin tune db db:1 db_conns_auditing enabled
rladmin tune db db:2 db_conns_auditing enabled

rladmin tune cluster db_conns_auditing enabled



# memtier
memtier_benchmark -s localhost -p 10670 -a redis --hide-histogram --pipeline=5 --threads=6 --test-time=20

#
memtier_benchmark -s localhost -p 10671 -a redis --hide-histogram --pipeline=5 --threads=6 --test-time=20




````


