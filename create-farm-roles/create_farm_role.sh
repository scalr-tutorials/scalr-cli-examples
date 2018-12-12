# #!/usr/bin/env bash
export vpcid='vpc-xxx'
export roleid='1'
export cloudLocation='us-east-1'
export subnet='subnet-xxx'
export insttype='t2.small'
export farmSG='sg-xxxx'
export FName='testrole'
export farmid=($1)

# build the role with variables
rm buildrole.json
cat farm-role-ec2.json | jq '.alias=env.FName'| jq '.networking.networks[].id=env.vpcid'|jq '.networking.subnets[].id=env.subnet' | jq '.role.id=env.roleid' | jq '.cloudLocation=env.cloudLocation'| jq '.instanceType.id=env.insttype' |jq '.security.securityGroups[].id=env.farmSG'  > buildrole.json

echo $farmid
export farmroleid=`scalr-ctl farm-roles create --farmId $farmid --stdin < buildrole.json | jq '.data.id'`
echo $farmroleid
