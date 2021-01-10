#!/bin/bash
DEFAULT_TAGS="pharoz/domoticz:$(date '+%Y%m%d')"
echo -n "TAGS [${DEFAULT_TAGS}]:"
read TAGS
for TAG in ${TAGS:-${DEFAULT_TAGS}}; do
    docker build -t "$TAG" .
done
