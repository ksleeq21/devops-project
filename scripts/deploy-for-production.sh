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


# Update config files 
sed -i -e "s/DEPLOYMENT_NAME/${DEPLOYMENT_NAME}/g" $DEPLOYMENT_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $DEPLOYMENT_FILE
sed -i -e "s/SERVICE_NAME/${SERVICE_NAME}/g" $SERVICE_FILE 
sed -i -e "s/DEPLOYMENT_NAME/${DEPLOYMENT_NAME}/g" $SERVICE_FILE 
sed -i -e "s/VERSION/${VERSION}/g" $SERVICE_FILE
echo "[DEPLOYMENT_FILE]" 
cat $DEPLOYMENT_FILE
echo "[SERVICE_FILE]" 
cat $SERVICE_FILE


# Check deployment
DUP_FOUND=$(echo -n $(kubectl get deploy ${DEPLOYMENT_NAME}-${VERSION}) | wc -m)
if [ $DUP_FOUND -ne 0 ]; then
    kubectl get deploy
    echo "Deployment ${DEPLOYMENT_NAME}-${VERSION} is already provisioned!"
    echo "Please check version number ${VERSION}"
    exit 1
fi


# Green deployment
echo "Start green deployment with ${DEPLOYMENT_FILE}"
kubectl apply -f $DEPLOYMENT_FILE
kubectl get deploy
echo "kubectl apply -f ${DEPLOYMENT_FILE} is done"


# Check green deployment readiness
echo "Check green deployment rediness"
READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [ "$READY" != "True" ]; do
    echo "Deploying ${DEPLOYMENT_NAME}-${VERSION}"
    READY=$(kubectl get deploy "${DEPLOYMENT_NAME}-${VERSION}" -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 5
done
echo "${DEPLOYMENT_NAME}-${VERSION} is deployed"
kubectl get deploy


# Check service
DUP_FOUND=$(echo -n $(kubectl get svc ${SERVICE_NAME}) | wc -m)
if [ $DUP_FOUND -eq 0 ]; then
    echo "Service ${SERVICE_NAME} not found, create a service!"
    kubectl apply -f $SERVICE_FILE
    echo "kubectl apply -f ${SERVICE_FILE} is done"
    kubectl get svc
    exit 0
fi

# Update the service selector with the new version
kubectl patch svc $SERVICE_NAME -p "{\"spec\":{\"selector\": {\"name\": \"${DEPLOYMENT_NAME}\", \"version\": \"${VERSION}\"}}}"
echo "Patch for ${SERVICE_NAME} is done"
kubectl get svc


# Health check
while [ "$STATUS_CODE" != "200" ]; do
    hostname=$(kubectl get service ${SERVICE_NAME} -o json | jq '.status.loadBalancer.ingress[].hostname' | tr -d '"')
    url="http://${hostname}:8000"
    STATUS_CODE=$(curl --write-out %{http_code} --silent --output /dev/null $url)
    echo "Connecting to ${url}"
    sleep 5
done
echo "${url} connected"


# Delete Blue Deployment
kubectl get deployments --sort-by=.metadata.name -o json | jq '.items[].metadata.name' | tr -d '"' | while read line ; do
    line="${line:1}"
    line=${line::-1}
    idx=$(echo $line | grep -b -o ${DEPLOYMENT_NAME} | awk 'BEGIN {FS=":"}{print $1}')
    if { [ $idx == "0" ] && [ $line != "${DEPLOYMENT_NAME}-${VERSION}" ] ;}; then
        kubectl delete deploy line
        echo "Deployment ${line} deleted"
    fi
done

echo "Deployment done!"
