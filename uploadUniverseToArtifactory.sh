set -e

UNIVERSE_PATH=$1
RELEASE_VERSION=$2
ENVIRONMENT=$3

if [ -z "$MAVEN_ARTIFACTORY_URL" ]; then
	echo " MAVEN_ARTIFACTORY_URL environment variable not set, so setting default"
fi

if [ -z "$MDSBOT_ARTIFACTORY_APIKEY" ]; then
	echo " MDSBOT_ARTIFACTORY_APIKEY environment variable not set, so setting default"
fi

if [ -z "$MDSBOT_ARTIFACTORY_USERNAME" ]; then
	echo " MDSBOT_ARTIFACTORY_USERNAME environment variable not set, so setting default"
fi



ARTIFACTS_PATH=dcos/universe/${RELEASE_VERSION}/${ENVIRONMENT}


curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${ARTIFACTS_PATH}/repo-up-to-1.8.json" -T $UNIVERSE_PATH/repo-up-to-1.8.json
curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${ARTIFACTS_PATH}/repo-up-to-1.9.json" -T $UNIVERSE_PATH/repo-up-to-1.9.json
curl -u $MDSBOT_ARTIFACTORY_USERNAME:$MDSBOT_ARTIFACTORY_APIKEY -X PUT "${MAVEN_ARTIFACTORY_URL}/${ARTIFACTS_PATH}/repo-up-to-1.10.json" -T $UNIVERSE_PATH/repo-up-to-1.10.json
