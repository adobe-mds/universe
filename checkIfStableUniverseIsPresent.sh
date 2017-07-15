

set -e

RELEASE_VERSION=$1
MAVEN_ARTIFACTORY_URL=$2
ENVIRONMENT=$3



JSON_PATH=dcos/universe/${RELEASE_VERSION}/${ENVIRONMENT}
STABLE_JSON_PATH=${JSON_PATH}-stable

mkdir -p tempDownloadLoc
wget "${MAVEN_ARTIFACTORY_URL}/${STABLE_JSON_PATH}/repo-up-to-1.8.json" -P tempDownloadLoc

if [ $? -ne 0 ]; then
	echo "Dev stable version of universe Json - ${RELEASE_VERSION} doesn't exists" 
	exit 1
fi