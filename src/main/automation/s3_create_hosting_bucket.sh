#!/usr/bin/env bash

# For the list of names
# Create the s3 buckets for website hosting
# Associate the website hosting policy and bucket public access policy

export SCRIPT_NAME="$0"
if [ $# -ne 2 ]
then
    echo "Missing arguments"
    echo "Usage: $SCRIPT_NAME profile bucket-suffix"
    echo "Usage: The script also expects a file 'users' in the same folder"
    exit 1
fi

export BUCKET_SUFFIX="$2"
export REGION_NAME="us-east-1"

while read username
do
    echo "For user ${username}"
    export BUCKET_NAME="${username}.${BUCKET_SUFFIX}"
    aws --profile $1 --region ${REGION_NAME} s3 rb --force s3://${BUCKET_NAME}
    aws --profile $1 --region ${REGION_NAME} s3 mb s3://${BUCKET_NAME}
    aws --profile $1 --region ${REGION_NAME} s3 website s3://${BUCKET_NAME} --index-document index.html
    cp website_hosting_bucket_policy.json.template website_hosting_bucket_policy.json
    sed -i '' "s/bucket_name/${BUCKET_NAME}/" website_hosting_bucket_policy.json
    aws --profile $1 --region ${REGION_NAME} s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy file://website_hosting_bucket_policy.json
    aws --profile $1 --region ${REGION_NAME} s3 cp index.html s3://${BUCKET_NAME}/
    echo "URL: http://${BUCKET_NAME}.s3-website-${REGION_NAME}.amazonaws.com"
done < users
