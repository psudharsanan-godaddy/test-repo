# Commerce App Helm Chart V2

The goals of building this new Helm chart for deploying commerce applications are to replace the bash-script-based deployment processes and to standardize the deployment of all NES applications, including Kubernetes resource templates, config file formats, mount paths, etc.

```bash
APP=currency-exchange
helm template . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.a.yaml \
 -f ./values/app-specific/$APP/cp.yaml \
 -f ./values/app-specific/$APP/cp.dp.yaml \
 -f ./values/app-specific/$APP/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.21 \
 --set cdJobsBranchName=EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --debug \
 > .output/$APP.yaml
```

```bash
helm upgrade --install currency-exchange-ep-43093 . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.a.yaml \
 -f ./values/app-specific/currency-exchange/cp.yaml \
 -f ./values/app-specific/currency-exchange/cp.dp.yaml \
 -f ./values/app-specific/currency-exchange/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.21 \
 --set cdJobsBranchName=EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --debug \
 --atomic
```


```bash
helm upgrade --install tax-rates-service-ep-43093 . \
 -f ./values/base/cp.yaml \
 -f ./values/base/cp.dp.yaml \
 -f ./values/base/cp.dp.gen.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.yaml \
 -f ./values/base/cp.dp.gen.us-east-1.shared.a.yaml \
 -f ./values/app-specific/tax-rates/cp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.10 \
 --set cdJobsBranchName=EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --debug \
 --atomic
```

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
'secret/###APP###-vertx-config'
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
 -f ./values/base/cp.dp.gen.us-east-1.shared.a.yaml \
 -f ./values/app-specific/tax-rates/cp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.10 \
 --set cdJobsBranchName=master \
 --set currentPrimaryRegion=us-east-1 \
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
 -f ./values/base/cp.dp.gen.us-east-1.shared.a.yaml \
 -f ./values/app-specific/tax-rates/cp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.yaml \
 -f ./values/app-specific/tax-rates/cp.dp.us-east-1.yaml \
 --set deployment.image.tag=0.0.10 \
 --set cdJobsBranchName=EP-43093 \
 --set currentPrimaryRegion=us-east-1 \
 --debug \
 > .output/tax-rates.yaml
```
