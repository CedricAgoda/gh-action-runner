#!/bin/bash

cd $(dirname $0)

if [ "" != "${GHAR_OLD_TOKEN}" ];
then
    ./config.sh remove --token ${GHAR_OLD_TOKEN}
fi

if [ "" != "${GHAR_TOKEN}" ];
then
    ./config.sh --url ${GHAR_REPO} --token ${GHAR_TOKEN}
fi

if [ "" != "${GHAR_RUN}" ];
then
    ./run.sh
fi

if [ "" != "$1" ];
then
    $1
fi