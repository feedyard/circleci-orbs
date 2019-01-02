#!/usr/bin/env bash
#
# input params
# 1 = aws access key for the pipeline service account identity
# 2 = aws secret key for the pipeline service account identity
# 3 = aws region to use
# 4 = role to assume or 'none' if not needed, script will fail if not provided

# add check for valid number of parameters
if [ $# == 0 ] || [ $# == 2 ] || [ $# -gt 4 ]; then
    echo "incorrect number of parameters"
    exit 1
fi


# add 'version' as a parameter to validate the version of this script being used
if [ $1 == "version" ]; then
    echo "1.2.0"
    exit 0
fi

mkdir -p ~/.aws

cat <<EOF >  ~/.aws/credentials
[default]
aws_access_key_id=$1
aws_secret_access_key=$2
region=$3
EOF

if [ $# == 4 ]; then
    TMP="$(aws sts assume-role --output json --role-arn ${4} --role-session-name $CIRCLE_PROJECT_REPONAME || { echo 'sts failure!' ; exit 1; })"

    ACCESS_KEY=$(echo $TMP | jq -r ".Credentials.AccessKeyId")
    SECRET_KEY=$(echo $TMP | jq -r ".Credentials.SecretAccessKey")
    SESSION_TOKEN=$(echo $TMP | jq -r ".Credentials.SessionToken")
    EXPIRATION=$(echo $TMP | jq -r ".Credentials.Expiration")

    cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id=${ACCESS_KEY}
aws_secret_access_key=${SECRET_KEY}
aws_session_token=${SESSION_TOKEN}
region=$3
EOF
fi