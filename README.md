# Commerce App Helm Chart V2

The goals of building this new Helm chart for deploying commerce applications are to replace the bash-script-based deployment processes and to standardize the deployment of all NES applications, including Kubernetes resource templates, config file formats, mount paths, etc.

# Local development

## Generate YAML output

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

## Deploy from local machine

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

## Run unit tests

`mvn clean verify -f test/pom.xml`

# Helm existing resources adoption

```bash
resourceNameTemplates=(
'externalsecret/###APP###-classic-db-configexternal'
'externalsecret/###APP###-crypto-config'
'externalsecret/###APP###-db-config'
'configmap/###APP###-log-config'
'secret/###APP###-auth-config'
'secret/###APP###-db-config'
'secret/###APP###-prometheus-config'
'secret/###APP###-app-config'
'secret/###APP###-vertx-options'
'deployment/###APP###-deployment'
)
app=tax-rates
helmReleaseName=tax-rates-service
for template in ${resourceNameTemplates[@]}; do
  resourceName=$(echo $template | sed "s/###APP###/$app/")
  if [[ ! -z "$(kubectl get $resourceName --ignore-not-found)" ]]; then
    kubectl label $resourceName app.kubernetes.io/managed-by=Helm
    kubectl annotate $resourceName meta.helm.sh/release-name=$helmReleaseName
    kubectl annotate $resourceName meta.helm.sh/release-namespace=default
  else
    echo $resourceName does not exist, skipping...
  fi
done
```

```bash
helm upgrade --install tax-rates-service . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/app-specific/tax-rates/cp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.10 \
 --set deploymentSuffix=master \
 --set currentPrimaryRegion=us-east-1 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --debug \
 --atomic
```

```bash
helm template . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/app-specific/tax-rates/cp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.10 \
 --set deploymentSuffix=--EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --set clusterSide=a \
 --set liveClusterSide=a \
 --debug \
 > .output/tax-rates.yaml
```

# Use cases

## Launch a new service

1. Create a branch of cd-jobs, add an entry in the app-manifest.json and get it merged into master
2. Create a branch of the Helm chart repo, add all necessary values files, blocks and get it merged into master
3. Run app-setup to have app-speicific resources created, e.g. jks secret, hosts config secret, ECR repo, IngressRoute, HPA, NLB Ingress, ClusterIP Svc, Route 53 records, APIG etc.
4. Merge the app repo branch to master to trigger build and deploy the app repo to DP

## Update an existing service

### Update a config (hosts)

1. Create a branch of the Helm chart repo, update all necessary values files, blocks
2. Run the app-setup against that Helm chart branch (hosts)
3. Deploy the app using the Helm chart against that Helm chart branch (auth, db, etc.)
4. Access the branch-deployment of the app using port forwarding to the ClusterIP svc
5. Have the Helm chart branch merged into master (triggers an automatic cleanup)
6. Deploy the app with the updated Helm chart

### Update a config (auth, db, etc.)

1. Create a branch of the Helm chart repo, update all necessary values files, blocks
2. Deploy the app using the Helm chart against that Helm chart branch (auth, db, etc.)
3. Access the branch-deployment of the app using port forwarding to the ClusterIP svc
4. Have the Helm chart branch merged into master (triggers an automatic cleanup)
5. Deploy the app with the updated Helm chart

### Update the app code

1. Create a branch of the app repo and make updates
2. Deploy the app against that app repo branch
