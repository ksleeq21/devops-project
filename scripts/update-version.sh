#!/bin/bash
DEPLOYMENT_NAME=$1
DEPLOYMENT_FILE=$2
VERSION=$3

echo "update version"
echo "DEPLOYMENT_NAME: ${DEPLOYMENT_NAME}"
echo "DEPLOYMENT_FILE: ${DEPLOYMENT_FILE}"
echo "VERSION        : ${VERSION}"

# Create green deployment
sed -i -e "s/DEPLOYMENT_NAME/${DEPLOYMENT_NAME}/g" $DEPLOYMENT_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $DEPLOYMENT_FILE

echo "+++ Green Deployment, filename: ${DEPLOYMENT_FILE} +++"
cat $DEPLOYMENT_FILE
echo ""
