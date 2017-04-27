#!/bin/bash

#python3 must be installed
#sudo pip3 install jsonschema

echo 'Generating Universe'
/bin/bash scripts/build.sh

#S3 parameters
S3KEY=$AWS_ACCESS_KEY_ID
S3SECRET=$AWS_SECRET_ACCESS_KEY
S3BUCKET=$S3_BUCKET
S3STORAGETYPE="STANDARD" #REDUCED_REDUNDANCY or STANDARD etc.
UNIVERSE_VERSION=$UNIVERSE_VERSION

function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket="${S3BUCKET}"
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3"
  storage_type="x-amz-storage-class:${S3STORAGETYPE}"
  string="PUT\n\n$content_type\n$date\n$acl\n$storage_type\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  echo 'going to upload'
  curl -s -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$storage_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}

echo 'Uploading to S3'
putS3 "target" "repo-up-to-1.8.json" "/dcos-universe/${UNIVERSE_VERSION}/1.8/"

putS3 "target" "repo-up-to-1.9.json" "/dcos-universe/${UNIVERSE_VERSION}/1.9/"

putS3 "target" "repo-up-to-1.10.json" "/dcos-universe/${UNIVERSE_VERSION}/1.10/"

