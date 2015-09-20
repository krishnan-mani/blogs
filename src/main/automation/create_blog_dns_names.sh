#!/usr/bin/env bash

# Create CNAME record

export SCRIPT_NAME="$0"
if [ $# -ne 6 ]
then
    echo "Missing arguments"
    echo "Usage: $SCRIPT_NAME profile bucket-name host-name sub-domain hosted-zone-id path-to-change-set"
    exit 1
fi

export BUCKET_NAME="$2"
export HOSTNAME="$3"
export SUB_DOMAIN="$4"
export HOSTED_ZONE_ID="$5"
export PATH_TO_CHANGE_SET="$6"
export REGION_NAME="eu-west-1"

    export FQDN="${HOSTNAME}.${SUB_DOMAIN}.equalexperts.in"
    export POINTS_TO="${BUCKET_NAME}.s3-website-${REGION_NAME}.amazonaws.com"
    cp cname_resource_record_set.json.template cname_resource_record_set.json
    sed -i '' "s/FQDN/${FQDN}/" cname_resource_record_set.json
    sed -i '' "s/POINTS_TO/${POINTS_TO}/" cname_resource_record_set.json

    aws --profile $1 route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --change-batch file://${PATH_TO_CHANGE_SET}/cname_resource_record_set.json
