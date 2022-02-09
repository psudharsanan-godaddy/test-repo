#!/usr/bin/env bash

if [[ -z "$ENV" || -z "$ACCOUNT_TYPE" || -z "$AWS_REGION" || -z "$CLUSTER_TYPE" || -z "$CLUSTER_SIDE" || -z "$APP" ]]; then
  echo "ENV, ACCOUNT_TYPE, AWS_REGION, CLUSTER_TYPE, CLUSTER_SIDE, APP environment variables need to be set!"
  echo "e.g. ENV=dp ACCOUNT_TYPE=gen AWS_REGION=us-west-2 CLUSTER_TYPE=shard CLUSTER_SIDE=a APP=currency-exchange ./scripts/render-values-files.sh"
  exit 1
fi

# the lookup order is also documented at values/README.md
lookupPaths=(
  "base/cp.yaml"
  "base/cp.$ENV.yaml"
  "base/cp.$ENV.$ACCOUNT_TYPE.yaml"
  "base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml"
  "base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.yaml"
  "base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.$CLUSTER_SIDE.yaml"
  "app-specific/$APP/cp.yaml"
  "app-specific/$APP/cp.$ENV.yaml"
  "app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.yaml"
  "app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml"
  "app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.yaml"
  "app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.$CLUSTER_SIDE.yaml"
  "protected-base/cp.yaml"
  "protected-base/cp.$ENV.yaml"
  "protected-base/cp.$ENV.$ACCOUNT_TYPE.yaml"
  "protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml"
  "protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.yaml"
  "protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.$CLUSTER_SIDE.yaml"
  "protected-app-specific/$APP/cp.yaml"
  "protected-app-specific/$APP/cp.$ENV.yaml"
  "protected-app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.yaml"
  "protected-app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml"
  "protected-app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.yaml"
  "protected-app-specific/$APP/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$CLUSTER_TYPE.$CLUSTER_SIDE.yaml"
)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
delimiter=''
for valuesFile in "${lookupPaths[@]}"; do
  valuesFilePath="./values/$valuesFile"
  if [[ -f "$valuesFilePath" ]]; then
    valuesFiles=$valuesFiles$delimiter$valuesFilePath
    delimiter=' '
  fi
done

yq eval-all '. as $item ireduce ({}; . * $item )' $valuesFiles
