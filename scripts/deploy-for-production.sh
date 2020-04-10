#!/bin/bash

# if [ "$#" -ne 4 ]; then
#   echo "Number of input arguments: ${$#}"
#   echo "Usage: ./scripts/deploy-for-production.sh SERVICE_NAME DEPLOYMENT_NAME VERSION DEPLOYMENT_FILE" >&2
#   exit 1
# fi

SERVICE_NAME=$1
DEPLOYMENT_NAME=$2
VERSION=$3
DEPLOYMENT_FILE=$4

echo 'Deploy for production'
echo "SERVICE_NAME    : ${SERVICE_NAME}"
echo "DEPLOYMENT_NAME : ${DEPLOYMENT_NAME}"
echo "VERSION         : ${VERSION}"
echo "DEPLOYMENT_FILE : ${DEPLOYMENT_FILE}"

DUP_FOUND=$(echo -n $(kubectl get deploy dp-devops-project-1.0.2) | wc -m)
echo "DUP_FOUND: ${DUP_FOUND}"
# Check deployment
if [$DUP_FOUND -eq 0]; then
    echo "Deployment ${DEPLOYMENT_NAME}-${VERSION} is already provisioned!"
    exit 1
fi

echo "Test done"
exit 0

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
