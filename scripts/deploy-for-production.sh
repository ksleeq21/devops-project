#!/bin/bash

NAMESPACE=$1
SERVICE_NAME=$2
DEPLOYMENT_NAME=$3
VERSION=$4

echo 'Deploy for production'
echo "[NAMESPACE] - Namespace of the application: ${NAMESPACE}"
echo "[SERVICE_NAME] - Name of the current service: ${SERVICE_NAME}"
echo "[DEPLOYMENT_NAME] - The name of the current deployment: ${DEPLOYMENT_NAME}"
echo "[VERSION] - The next version of the Docker image: ${VERSION}"
