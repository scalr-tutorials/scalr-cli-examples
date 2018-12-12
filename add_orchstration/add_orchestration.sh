#!/bin/bash

export farmroleid=$1

# clean up first
rm baseorch.json

# create base script file
cat <<EOF >> baseorch.json
 {
      "trigger": {
        "event": {
          "id": "HostUp"
        },
        "triggerType": "SpecificEventTrigger"
      },
      "target": {
        "targetType": "TriggeringServerTarget"
      },
      "action": {
        "actionType": "ScalrScriptAction",
        "scriptVersion": {
          "script": {
            "id": 136
          },
          "version": -1
        }
      },
      "timeout": 180,
      "runAs": "",
      "order": 10,
      "blocking": true,
      "scope": "farmrole",
      "enabled": true
    }
EOF

scalr-ctl farm-role-orchestration-rules create --farmRoleId $farmroleid --stdin < baseorch.json
