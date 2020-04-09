#!/usr/bin/env bash

# Build image and add a descriptive tag
docker build -t ksleeq21/devops-project .

# List docker images
docker image ls 

# Run flask app
docker run -p 8000:8000 ksleeq21/devops-project