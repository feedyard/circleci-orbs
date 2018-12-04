#!/bin/ash -eo pipefail

for ORB in src/*; do
  echo "Dev release $ORB ..."

  circleci orb publish $CIRCLE_PROJECT_USERNAME/$ORB@dev:$CIRCLE_SHA1 --token $CIRCLECI_API_TOKEN; RETURN_CODE=$?
  circleci orb publish $CIRCLE_PROJECT_USERNAME/$ORB@dev:latest --token $CIRCLECI_API_TOKEN; RETURN_CODE=$?

  if [[ $RETURN_CODE != 0 ]]; then
  	exit 1
  fi
done

