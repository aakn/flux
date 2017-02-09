#!/bin/bash
[ $# -lt 1 ] && echo "Usage `basename $0`<SFS Shadow Jar Path> <SFS Flux File Path> <VERSION>" && exit 1

SHADOW_JAR=$1
CONFIG_FILE=$2
VERSION=$3

DEPLOYMENT_UNIT_PATH=/tmp/workflows
DEPLOYMENT_UNIT_NAME=sfs_wf

echo "cleaning the older deployments"
rm -rf ${DEPLOYMENT_UNIT_PATH}

echo "Creating deployment unit structure"
mkdir -p ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/${VERSION}/main
mkdir -p ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/${VERSION}/lib

echo "Copying jars to deployment unit"
cp ${SHADOW_JAR} ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/${VERSION}/main
cp ${CONFIG_FILE} ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/${VERSION}/flux_config.yml
