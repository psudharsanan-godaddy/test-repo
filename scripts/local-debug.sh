#!/bin/bash

manuallyInserted=false

getApp() {
  if [[ -z $APP ]]; then
    echo "Insert APP value:"
    read input
    export APP="$input"
    export APP
    echo "APP input saved = $APP"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using APP = $APP"
}

getENV() {
  if [[ -z $ENV ]]; then
    echo "Insert ENV value one of: dp, test, ote, prod:"
    read input
    export ENV="$input"
    echo "ENV input saved = $ENV"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using ENV = $ENV"
}

getACCOUNT_TYPE() {
  if [[ -z $ACCOUNT_TYPE ]]; then
    echo "Insert ACCOUNT_TYPE value one of: pci, icp, gen:"
    read input
    export ACCOUNT_TYPE="$input"
    echo "ACCOUNT_TYPE input saved = $ACCOUNT_TYPE"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using ACCOUNT_TYPE = $ACCOUNT_TYPE"
}

getAwsRegion() {
  if [[ -z $AWS_REGION ]]; then
    echo "Insert AWS_REGION value one of: us-east-1, us-west-2:"
    read input
    export AWS_REGION="$input"
    echo "AWS_REGION input saved = $AWS_REGION"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using AWS_REGION = $AWS_REGION"
}

getAppType() {
  if [[ -z $APP_TYPE ]]; then
    echo "Insert APP_TYPE value one of: service, reader:"
    read input
    export APP_TYPE="$input"
    echo "APP_TYPE input saved = $APP_TYPE"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using APP_TYPE = $APP_TYPE"
}

getApiVersion() {
  if [[ -z $API_VERSION ]]; then
    echo "Insert API_VERSION value, example: v1 :"
    read input
    export API_VERSION="$input"
    echo "API_VERSION input saved = $API_VERSION"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using API_VERSION = $API_VERSION"
}

getImageTag() {
  if [[ -z $IMAGE_TAG ]]; then
    echo "Insert IMAGE_TAG value, example: 0.0.1 :"
    read input
    export IMAGE_TAG="$input"
    echo "IMAGE_TAG input saved = $IMAGE_TAG"
    echo "------------------------------------------------"
    manuallyInserted=true
  fi
  echo "Using IMAGE_TAG = $API_VERSION"
}

runHelm() {
helm template . \
 -f ./values/base/cp.yaml \
 -f ./values/app-specific/$APP/cp.yaml \
 -f ./values/protected-base/cp.yaml \
 -f ./values/protected-base/cp.$ENV.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.shared.yaml \
 --set deployment.image.tag=$IMAGE_TAG \
 --set deploymentSuffix='' \
 --set currentPrimaryRegion=us-west-2 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --set app.name=$APP \
 --set app.apiVersion=$API_VERSION \
 --set app.pathNoun=$APP \
 --set app.resourceIdPathParamName=$RESOURCE_ID_PATH_PARAM_NAME \
 --set app.artifactId=$APP-service \
 --set app.type=$APP_TYPE \
 --debug \
 > $APP.yaml
}

printMessage(){
   if [ "$manuallyInserted" = true ] ; then
       echo "You might want to export all env variables before using this script several times.
       Like this (copy and execute suggestion below):
       export APP=$APP
       export ENV=$ENV
       export ACCOUNT_TYPE=$ACCOUNT_TYPE
       export AWS_REGION=$AWS_REGION
       export APP_TYPE=$APP_TYPE
       export API_VERSION=$API_VERSION
       export IMAGE_TAG=$IMAGE_TAG
       "
   fi
  echo "CHECK OUTPUT > $APP.yaml"
}

getApp
getENV
getACCOUNT_TYPE
getAwsRegion
getAppType
getApiVersion
getImageTag
runHelm
printMessage

