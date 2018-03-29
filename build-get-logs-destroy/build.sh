#!/bin/bash

export JOB_NAME=dev
export FName=demo-$JOB_NAME

# Create farm and get ID
farm_template=$JOB_NAME.json
cat server.json  | jq '.farm.name=env.FName' > $farm_template
farmid=$(scalr-ctl farms create-from-template --stdin < $farm_template | jq '.data.id')
echo "$farmid"

# launch farm
scalr-ctl  farms launch --farmId "$farmid"

#give scalr time to kick off
sleep 60

# get server id
scalr-ctl  farms list-servers --farmId "$farmid"
serverid=$(scalr-ctl farms list-servers --farmId "$farmid" | jq '.data[0].id'|tr -d '"')
orchserverid='"'$serverid'"'

echo "$serverid"
echo "$orchserverid"

# loop till the server is up and running
while [ "$serverstatus" != "running" ]
 do echo "Status: $serverstatus"
	serverstatus=$(scalr-ctl servers get --serverId "$serverid"| jq '.data.status'| tr -d '"')
	sleep 30
done

# sleep 60 to give scalr time to run scripts
sleep 60

# get orchestration log id
orchlogid=$(scalr-ctl scripts list-orchestration-logs | jq ".data[] | select(.server.id | contains($orchserverid)).id"| sed "s/\"//g")

# get orchestration logs
scalr-ctl  scripts get-orchestration-log --logEntryId "$orchlogid"| jq '.data.result'

# verify exit code
if [ "$(scalr-ctl  scripts get-orchestration-log --logEntryId "$orchlogid" | jq '.data.executionExitCode')" != 0 ]
 then
 exit 1
fi
      # clean up
scalr-ctl farms terminate --farmId "$farmid"

# loop till the server has been terminated
while [ "$serverstatus" != "terminated" ]
 do echo "Status: $serverstatus"
	serverstatus=$(scalr-ctl  servers get --serverId "$serverid" | jq '.data.status'| tr -d '"')
	sleep 30
done

# delete farm
scalr-ctl farms delete --farmId "$farmid"
