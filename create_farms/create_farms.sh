#!/usr/bin/env bash

# CSV format
# Farm Name,X,X

export config=~/.scalr/default.yaml
export projectid=$2
export inputfile=$1

#make folder to hold jsonfiles
mkdir -p ./json

# create farm teamplates
for x in $(awk -F"," '{ print $1 }' $inputfile | awk 'NR>1' )
 do export farmname=$x ; cat farm_template.json | jq '.project.id=env.projectid' | jq '.description=env.farmname' | jq '.name=env.farmname' | jq '.timezone="America\/Chicago"' > ./json/$farmname.json
done

# create the farms
for x in $(ls ./json/*.json)
do
  export farmid=`scalr-ctl --config $config farms create-from-template --stdin < $x | jq '.data.id'`
  echo $farmid
  scalr-ctl --config $config farms launch --farmId $farmid
  # add Farm roles
  # scalr-ctl farm-roles create --farmId $farmid --stdin < farm-role.json
done
