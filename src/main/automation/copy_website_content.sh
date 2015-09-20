#!/usr/bin/env bash

# Copy content recursively from source location to the destination website hosting bucket

export SCRIPT_NAME="$0"
if [ $# -ne 3 ]
then
    echo "Missing arguments"
    echo "Usage: $SCRIPT_NAME profile source-location bucket-name"
    exit 1
fi

export SOURCE_LOCATION="$2"
export BUCKET_NAME="$3"
aws --profile $1 s3 sync ${SOURCE_LOCATION} s3://${BUCKET_NAME}
