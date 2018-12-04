#!/bin/ash -eo pipefail

curl -X POST -H "Content-type: application/json" --data $1 $SLACK_WEBHOOK