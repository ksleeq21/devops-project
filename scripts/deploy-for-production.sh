#!/bin/bash

SERVICE_NAME=$1
DEPLOYMENT_NAME=$2
VERSION=$3
DEPLOYMENT_FILE=$4

echo 'Deploy for production'
echo "SERVICE_NAME    : ${SERVICE_NAME}"
echo "DEPLOYMENT_NAME : ${DEPLOYMENT_NAME}"
echo "VERSION         : ${VERSION}"
echo "DEPLOYMENT_FILE : ${DEPLOYMENT_FILE}"

# Check deployment
if ! kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}"; then
    echo "Deployment ${DEPLOYMENT_NAME}-${VERSION} is already provisioned!"
    exit 1
fi

# Create green deployment
sed -i -e "s/NAME/${DEPLOYMENT_NAME}/g" $DEPLOYMENT_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $DEPLOYMENT_FILE

kubectl apply -f $DEPLOYMENT_FILE

# Check green deployment readiness
READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$READY" != "True" ]]; do
    READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done

# Update the service selector with the new version
kubectl patch svc $SERVICE -p "{\"spec\":{\"selector\": {\"name\": \"${DEPLOYMENT_NAME}\", \"version\": \"${VERSION}\"}}}"

echo "Deployment done!"
