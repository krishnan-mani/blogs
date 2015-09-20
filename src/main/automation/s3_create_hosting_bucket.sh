#!/usr/bin/env bash

# Create the s3 buckets for website hosting
# Associate the website hosting policy and bucket public access policy

export SCRIPT_NAME="$0"
if [ $# -ne 2 ]
then
    echo "Missing arguments"
    echo "Usage: $SCRIPT_NAME profile bucket-name"
    exit 1
fi

export BUCKET_NAME="$2"
export REGION_NAME="eu-west-1"

    aws --profile $1 s3 rb --force s3://${BUCKET_NAME}
    aws --profile $1 s3 mb s3://${BUCKET_NAME}
    aws --profile $1 s3 website s3://${BUCKET_NAME} --index-document index.html
    cp website_hosting_bucket_policy.json.template website_hosting_bucket_policy.json
    sed -i '' "s/bucket_name/${BUCKET_NAME}/" website_hosting_bucket_policy.json
    aws --profile $1 s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy file://website_hosting_bucket_policy.json
    aws --profile $1 s3 cp index.html s3://${BUCKET_NAME}/
    echo "URL: http://${BUCKET_NAME}.s3-website-${REGION_NAME}.amazonaws.com"
