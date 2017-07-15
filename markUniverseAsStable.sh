set -e

RELEASE_VERSION=$1
MDSBOT_ARTIFACTORY_APIKEY=$2
MDSBOT_ARTIFACTORY_USERNAME=$3
MAVEN_ARTIFACTORY_URL=$4
AWS_SECRET_ACCESS_KEY=$5
AWS_ACCESS_KEY_ID=$6
S3_BUCKET=$7
ENVIRONMENT=$8


export RELEASE_VERSION=$RELEASE_VERSION
export MDSBOT_ARTIFACTORY_APIKEY=$MDSBOT_ARTIFACTORY_APIKEY
export MDSBOT_ARTIFACTORY_USERNAME=$MDSBOT_ARTIFACTORY_USERNAME
export MAVEN_ARTIFACTORY_URL=$MAVEN_ARTIFACTORY_URL
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export S3_BUCKET=$S3_BUCKET



JSON_PATH=dcos/universe/${RELEASE_VERSION}/${ENVIRONMENT}

mkdir -p tempDownloadFolder
wget "${MAVEN_ARTIFACTORY_URL}/${JSON_PATH}/repo-up-to-1.8.json" -P tempDownloadFolder
wget "${MAVEN_ARTIFACTORY_URL}/${JSON_PATH}/repo-up-to-1.9.json" -P tempDownloadFolder
wget "${MAVEN_ARTIFACTORY_URL}/${JSON_PATH}/repo-up-to-1.10.json" -P tempDownloadFolder


STABLE_JSON_PATH=${JSON_PATH}-stable
curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${STABLE_JSON_PATH}/repo-up-to-1.8.json" -T  tempDownloadFolder/repo-up-to-1.8.json
curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${STABLE_JSON_PATH}/repo-up-to-1.9.json" -T  tempDownloadFolder/repo-up-to-1.9.json
curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${STABLE_JSON_PATH}/repo-up-to-1.10.json" -T tempDownloadFolder/repo-up-to-1.10.json


##uploading same json to s3 also, with "stable" in its path
S3_URL="s3://${S3_BUCKET}/dcos/universe/${RELEASE_VERSION}/stable"
aws s3 --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp tempDownloadFolder/repo-up-to-1.8.json  ${S3_URL}/repo-up-to-1.8.json
aws s3 --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp tempDownloadFolder/repo-up-to-1.9.json  ${S3_URL}/repo-up-to-1.9.json
aws s3 --content-type="application/vnd.dcos.universe.repo+json;charset=utf-8;version=v3" cp tempDownloadFolder/repo-up-to-1.10.json  ${S3_URL}/repo-up-to-1.10.json
