#!/bin/bash

set -e

RELEASE_VERSION=$1
S3_BUCKET=$2
AWS_SECRET_ACCESS_KEY=$3
AWS_ACCESS_KEY_ID=$4

export S3_BUCKET=$S3_BUCKET
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID



S3_URL="s3://${S3_BUCKET}/dcos/universe/${RELEASE_VERSION}"
aws s3 --acl public-read --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp target/repo-up-to-1.8.json  ${S3_URL}/repo-up-to-1.8.json
aws s3 --acl public-read --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp target/repo-up-to-1.9.json  ${S3_URL}/repo-up-to-1.9.json
aws s3 --acl public-read --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp target/repo-up-to-1.10.json  ${S3_URL}/repo-up-to-1.10.json
