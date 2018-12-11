#!/bin/bash -eo pipefail

# for ORB in src/*; do
#  echo "Dev release $ORB ..."
#
#  #| grep $ORB
#  #if [ $? == 0 ]; then
#  if [ $(circleci orb list $CIRCLE_PROJECT_USERNAME) != *$ORB* ]; then
#     echo "first time orb published"
#     circleci orb create $CIRCLE_PROJECT_USERNAME/$ORB --token $CIRCLECI_API_TOKEN; RETURN_CODE=$?
#  fi
#
#  circleci orb publish $CIRCLE_PROJECT_USERNAME/$ORB@dev:$CIRCLE_SHA1 --token $CIRCLECI_API_TOKEN; RETURN_CODE=$?
#  circleci orb publish $CIRCLE_PROJECT_USERNAME/$ORB@dev:latest --token $CIRCLECI_API_TOKEN; RETURN_CODE=$?
#
#  if [[ $RETURN_CODE != 0 ]]; then
#  	exit 1
#  fi
#done
for ORB in src/*; do
  orbname=$(basename $ORB)
  printf %s "$(< ${ORB}/orb.yaml)" > $orbname.compare
  circleci orb source $CIRCLE_PROJECT_USERNAME/$orbname@dev:latest > $orbname.latest
  diff ${ORB}/orb.yaml $orbname.latest
done