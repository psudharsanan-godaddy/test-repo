# Commerce App Helm Chart V2

The goals of building this new Helm chart for deploying commerce applications are to replace the bash-script-based deployment processes and to standardize the deployment of all NES applications, including Kubernetes resource templates, config file formats, mount paths, etc.

## Table of Contents

1. [Local development](#local-development)
2. [FAQ](./docs/faq.md)
3. [Use cases](./docs/use-cases.md)

## Local development

### Setup

1. Install [asdf](https://asdf-vm.com/) with `brew install asdf`
2. Install required asdf plugins:
   1. `asdf plugin add helm`
   2. `asdf plugin add java`
   3. `asdf plugin add yq`
3. Install project dependencies with `asdf install` (project dependencies are defined in `./tool-versions`)

### Generate YAML output

```bash
APP=currency-exchange;RESOURCE_ID_PATH_PARAM_NAME=currencyExchangeId;AWS_REGION=us-west-2;APP_TYPE=service;API_VERSION=v2;
helm template . \
 -f ./values/base/cp.yaml \
 -f ./values/app-specific/$APP/cp.yaml \
 -f ./values/protected-base/cp.yaml \
 -f ./values/protected-base/cp.dp.yaml \
 -f ./values/protected-base/cp.dp.gen.yaml \
 -f ./values/protected-base/cp.dp.gen.$AWS_REGION.yaml \
 -f ./values/protected-base/cp.dp.gen.$AWS_REGION.shared.yaml \
 --set deployment.image.tag=0.0.21 \
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

```bash
helm upgrade --install currency-exchange-ep-43093 . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/app-specific/currency-exchange/cp.yaml \
 -f ./values/app-specific/currency-exchange/cp.dp.yaml \
 -f ./values/app-specific/currency-exchange/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.21 \
 --set deploymentSuffix=--EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --debug \
 --atomic
```

### Run unit tests

`mvn clean verify -f test/pom.xml`

### Render values files YAML

Now that there are multiple values files involved during a deployment of an application, a script is created to output the final values that will be used for deploying an application for local debugging purposes, e.g.:

```bash
ENV=dp ACCOUNT_TYPE=gen AWS_REGION=us-west-2 CLUSTER_TYPE=shard CLUSTER_SIDE=a APP=fulfillment-ui ./scripts/render-values-files.sh
```

Note that the generated values will not contain value fields passed in via `--set` as part of the Helm command, e.g. `helm upgrade ... --set app.name=fulfillment-ui`.
