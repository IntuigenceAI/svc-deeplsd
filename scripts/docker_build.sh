#!/bin/bash
shopt -so nounset pipefail

RED="\033[31m"
BOLD="\033[1m"
RESET="\033[0m"

echo "> Starting 'docker-build.sh'"; date; echo

PROJECT="svc-deeplsd" 

# TAG=$(poetry version --short)
TAG=$(git describe --dirty)

if [ "$#" -eq "1" ]; then
    HASH="${1}"
    TAG="${TAG}-${HASH}"
    echo "> Got git hash, build is not main, appended hash: '${TAG}'";
fi

echo "> Checking for existing tag..."
VERSIONS=$(az acr repository show-tags --name intaicr --repository intai/${PROJECT})
CHECK=$(jq -r ".[] | select(. == \"${TAG}\")" <<< ${VERSIONS})

if [[ $CHECK != "" ]]  ; then
    echo "${RED}${BOLD}> Cowardly refusing to overwrite an existing image tag.${RESET}"
    echo "> Found intai/${PROJECT}:${TAG} in the ACR registry."
    exit 1
fi
echo "> Didn't find tag '${TAG}', proceeding with build..."

docker build \
    --platform linux/amd64 \
    --build-arg AZURE_DEVOPS_PAT=${AZURE_DEVOPS_PAT} \
    -t intai/${PROJECT}:${TAG} .  # && \
# docker tag intai/${PROJECT}:${TAG} intaicr.azurecr.io/intai/${PROJECT}:${TAG} && \
# docker push intaicr.azurecr.io/intai/${PROJECT}:${TAG}

date; echo "> Finished 'docker-build.sh'"; echo
