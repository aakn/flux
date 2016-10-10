#!/bin/bash
[ $# -lt 1 ] && echo "Usage `basename $0`<SFS Shadow Jar Path> <SFS Flux File Path> <debug> <debug_port>" && exit 1

SHADOW_JAR=$1
CONFIG_FILE=$2
DEBUG=$3
DEBUG_PORT=$4

if [[ $# -ge 2 && "debug" == ${DEBUG} ]]; then
    [ $# -lt 3 ] && echo "Debug port not found. Usage `basename $0` <Example FQN> <debug> <debug_port>" && exit 1
fi


DEPLOYMENT_UNIT_PATH=/tmp/workflows
DEPLOYMENT_UNIT_NAME=sfs_wf

echo "cleaning the older deployments"
rm -rf ${DEPLOYMENT_UNIT_PATH}

echo "Creating deployment unit structure"
mkdir -p ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/main
mkdir -p ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/lib

echo "Copying jars to deployment unit"
cp ${SHADOW_JAR} ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/main
cp ${CONFIG_FILE} ${DEPLOYMENT_UNIT_PATH}/${DEPLOYMENT_UNIT_NAME}/flux_config.yml

if [[ $# -ge 3 && "debug" == ${DEBUG} ]]; then
    echo "Starting flux runtime in debug mode. Debug port: $DEBUG_PORT"
    java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=${DEBUG_PORT},suspend=y -cp "target/dependency/*" "com.flipkart.flux.initializer.FluxInitializer"
else
    echo "Starting flux runtime"
    java -cp "target/dependency/*" "com.flipkart.flux.initializer.FluxInitializer"
fi
