#!/bin/bash

#python3 must be installed
#sudo pip3 install jsonschema

echo 'Generating Universe'
/bin/bash scripts/build.sh

#S3 parameters
S3KEY=$S3KEY
S3SECRET=$S3SECRET
S3BUCKET=$S3BUCKET
S3STORAGETYPE="STANDARD" #REDUCED_REDUNDANCY or STANDARD etc.


function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket="${S3BUCKET}"
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:bucket-owner-full-control"
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
putS3 "target" "repo-up-to-1.8.json" "/dcos/universe/1.8/"



