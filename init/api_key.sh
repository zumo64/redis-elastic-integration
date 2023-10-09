#!/bin/bash
echo "creating api key..."
output=$(curl -s -X POST --cacert config/certs/ca/ca.crt -u "elastic:$1" -H "Content-Type: application/json" https://es01:9200/_security/api_key --data "@/tmp/api_key.json")
id=$(echo $output |  grep -o '"id":"[^"]*' | awk -F ':"' '{print $2}') 
apikey=$(echo $output | grep -o '"api_key":"[^"]*' | awk -F ':"' '{print $2}')
api_key="$id:$apikey" 
# sed has a bug in 4.7 so in place modification doesnt work 
# https://forums.docker.com/t/sed-couldnt-open-temporary-file-xyz-permission-denied-when-using-virtiofs/125473/4
sed "0,/APIKEY/s//$api_key/" /tmp/agent-config/elastic-agent.yml > /tmp/agent-config/elastic-agent-key.yml
echo "done creating apikey $api_key"
echo "elastic-agent.yml updated"