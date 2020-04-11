#!/bin/bash

DEPLOYMENT_NAME=$1
DEPLOYMENT_FILE=$2
VERSION=$3
SERVICE_NAME=$4
SERVICE_FILE=$5


echo 'Deploy for production'
echo "DEPLOYMENT_NAME : ${DEPLOYMENT_NAME}"
echo "DEPLOYMENT_FILE : ${DEPLOYMENT_FILE}"
echo "VERSION         : ${VERSION}"
echo "SERVICE_NAME    : ${SERVICE_NAME}"
echo "SERVICE_FILE    : ${SERVICE_FILE}"

# Check deployment
DUP_FOUND=$(echo -n $(kubectl get deploy ${DEPLOYMENT_NAME}-${VERSION}) | wc -m)
if [ $DUP_FOUND -ne 0 ]; then
    echo "Deployment ${DEPLOYMENT_NAME}-${VERSION} is already provisioned!"
    exit 1
fi


# Create green deployment
sed -i -e "s/DEPLOYMENT_NAME/${DEPLOYMENT_NAME}/g" $DEPLOYMENT_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $DEPLOYMENT_FILE
echo "+++ Green Deployment, filename: ${DEPLOYMENT_FILE} +++"
cat $DEPLOYMENT_FILE


# Green deployment
kubectl apply -f $DEPLOYMENT_FILE
echo "kubectl apply -f ${DEPLOYMENT_FILE} is done"


# Check green deployment readiness
READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$READY" != "True" ]]; do
    echo "Deploying ${DEPLOYMENT_NAME}-${VERSION}"
    READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "${DEPLOYMENT_NAME}-${VERSION} is deployed"



# Check service
DUP_FOUND=$(echo -n $(kubectl get svc ${SERVICE_NAME}) | wc -m)
if [ $DUP_FOUND -eq 0 ]; then
    echo "Service ${SERVICE_NAME} is not found, create a service!"
    kubectl apply -f $SERVICE_FILE
    echo "kubectl apply -f ${SERVICE_FILE} is done"
    exit 0
fi

# Update the service selector with the new version
kubectl patch svc $SERVICE_NAME -p "{\"spec\":{\"selector\": {\"name\": \"${DEPLOYMENT_NAME}\", \"version\": \"${VERSION}\"}}}"
echo "Patch for ${SERVICE_NAME} is done"


echo "Deployment done!"
