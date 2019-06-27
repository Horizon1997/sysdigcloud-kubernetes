#!/bin/bash

DIR="$(cd "$(dirname "$0")"; pwd -P)"
source "$DIR/shared-values.sh"

set -euo pipefail
. /sysdig-chart/framework.sh

APPS=$(yq -r .apps /sysdig-chart/values.yaml)
echo "${APPS}"
SECURE=false
for app in ${APPS}
do
 if [[ ${app} == "secure" ]]; then
  SECURE=true
 fi
done

broadcast "green" "Deploying Monitor..."
"$TEMPLATE_DIR/monitor.sh"
if [[ ${SECURE} == true ]]; then
  broadcast "green" "Deploying Secure..."
  "$TEMPLATE_DIR/secure.sh"
fi
