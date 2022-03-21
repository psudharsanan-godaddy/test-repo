# Commerce App Helm Chart V2

The goals of building this new Helm chart for deploying commerce applications are to replace the bash-script-based deployment processes and to standardize the deployment of all NES applications, including Kubernetes resource templates, config file formats, mount paths, etc.

## Table of Contents

1. [Local development](#local-development)
2. [FAQ](./docs/faq.md)
3. [Use cases](./docs/use-cases.md)

## Local development

### Setup

1. Install ASDF if you don't already have it: https://confluence.godaddy.com/display/CTOPLAT/ASDF-VM+Setup 
2. Then run: `asdf install` (it will install all versions in `.tool-versions`)

### Generate YAML output

The below script is just a sample, modify the values of variables if necessary.

```bash
APP=currency-exchange;ENV=dp;ACCOUNT_TYPE=gen;RESOURCE_ID_PATH_PARAM_NAME=currencyExchangeId;AWS_REGION=us-west-2;APP_TYPE=service;API_VERSION=v2;IMAGE_TAG=0.0.21;
helm template . \
 -f ./values/base/cp.yaml \
 -f ./values/app-specific/$APP/cp.yaml \
 -f ./values/protected-base/cp.yaml \
 -f ./values/protected-base/cp.$ENV.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.shared.yaml \
 --set deployment.image.tag=$IMAGE_TAG \
 --set deploymentSuffix='' \
 --set currentPrimaryRegion=us-west-2 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --set app.name=$APP \
 --set app.apiVersion=$API_VERSION \
 --set app.pathNoun=$APP \
 --set app.resourceIdPathParamName=$RESOURCE_ID_PATH_PARAM_NAME \
 --set app.artifactId=$APP-service \
 --set app.type=$APP_TYPE \
 --debug \
 > .output/$APP.yaml
```

### Deploy from local machine

The below script is just a sample, modify the values of variables if necessary.

```bash
APP=currency-exchange;ENV=dp;ACCOUNT_TYPE=gen;RESOURCE_ID_PATH_PARAM_NAME=currencyExchangeId;AWS_REGION=us-west-2;APP_TYPE=service;API_VERSION=v2;DEPLOYMENT_SUFFIX='--abcdefg';IMAGE_TAG=0.0.21;
helm upgrade --install "${APP}${DEPLOYMENT_SUFFIX}" . \
 -f ./values/base/cp.yaml \
 -f ./values/app-specific/$APP/cp.yaml \
 -f ./values/protected-base/cp.yaml \
 -f ./values/protected-base/cp.$ENV.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml \
 -f ./values/protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.shared.yaml \
 --set deployment.image.tag=$IMAGE_TAG \
 --set deploymentSuffix='--abcdefg' \
 --set currentPrimaryRegion=us-west-2 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --set app.name=$APP \
 --set app.apiVersion=$API_VERSION \
 --set app.pathNoun=$APP \
 --set app.resourceIdPathParamName=$RESOURCE_ID_PATH_PARAM_NAME \
 --set app.artifactId=$APP-service \
 --set app.type=$APP_TYPE \
 --debug \
 --atomic
```

### Run unit tests

`mvn clean verify -f test/pom.xml`

### Render values files YAML

Now that there are multiple values files involved during a deployment of an application, a script is created to output the final values that will be used for deploying an application for local debugging purposes, e.g.:

```bash
ENV=dp ACCOUNT_TYPE=gen AWS_REGION=us-west-2 CLUSTER_TYPE=shared CLUSTER_SIDE=a APP=fulfillment-ui ./scripts/render-values-files.sh
```

Note that the generated values will not contain value fields passed in via `--set` as part of the Helm command, e.g. `helm upgrade ... --set app.name=fulfillment-ui`.
