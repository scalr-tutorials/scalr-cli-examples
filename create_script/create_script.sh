export SCRIPT_NAME=test.sh

# clean up first
rm base.json

# create base script file
cat <<EOF >> base.json
{
   "timeoutDefault": 1,
   "description": "",
   "tags": [],
   "deprecated": false,
   "blockingDefault": true,
   "osType": "linux",
   "name": "$SCRIPT_NAME"
 }
EOF

scriptid=$(scalr-ctl scripts list | jq ".data[] | select(.name==\"$SCRIPT_NAME\").id")

if [ -z "$scriptid" ]
then
  echo "create base script"
  scriptid=$(scalr-ctl scripts create --stdin < base.json | jq .data.id)
fi

# get id
echo $scriptid

# convert script to json
export body=$(python -c 'import os, sys, json; y=open(os.environ["SCRIPT_NAME"], "r").read(); print(json.dumps(y))')

# clean up files
rm $SCRIPT_NAME.json

# create import file
cat <<EOF >> $SCRIPT_NAME.json
{
  "body": $body
}
EOF

# create script version
echo "adding scripts"
scalr-ctl script-versions create --scriptId $scriptid --stdin < $SCRIPT_NAME.json
