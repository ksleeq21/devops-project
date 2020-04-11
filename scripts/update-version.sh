#!/bin/bash
DEPLOYMENT_NAME=$1
DEPLOYMENT_FILE=$2
VERSION=$3

# Create green deployment
sed -i -e "s/DEPLOYMENT_NAME/${DEPLOYMENT_NAME}/g" $DEPLOYMENT_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $DEPLOYMENT_FILE

echo "+++ Green Deployment, filename: ${DEPLOYMENT_FILE} +++"
cat $DEPLOYMENT_FILE
echo ""
