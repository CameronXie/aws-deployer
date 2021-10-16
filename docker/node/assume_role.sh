#! /bin/bash

TOKEN=$1

unset AWS_SESSION_TOKEN

temp_role=$(aws sts assume-role \
                    --duration-seconds 3600 \
                    --role-arn "$ROLE_ARN" \
                    --role-session-name "assume_role" \
                    --serial-number "$MFA_DEVICE" \
                    --token-code "$TOKEN")

echo $temp_role

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

env | grep -i AWS_
