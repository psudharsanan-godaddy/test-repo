# FAQ

## What is Helm?

> [Helm](https://helm.sh/) helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

## Why using Helm?

- Organic organization of Kubernetes resources of an application
- Sophisticated templating engine
- Atomic installation and upgrade of applications
- Easy to customize and extend Helm charts
- Widely used at other parts of commerce systems (for managing third-party Kubernetes applications)

## How do we organize this Helm chart?

The following directories are used for generating templates of the helm release, please refer to their respective README for details:

- [config-content](../config-content/README.md)
- [templates](../templates/README.md)
- [values](../values/README.md)

The `test` folder contains a Java-based test project where we add tests to guard our Helm chart against breaking changes.

## What resources of an application are NOT managed by this Helm chart?

Currently, the following resources of an application are not managed by this Helm chart:

- Server CA certs (handled by the app-setup workflow)
- IngressRoute (handled by the app-setup workflow)
- ClusterIP and nlb services (handled by the app-setup workflow)
- Route 53/Corp DNS records (handled by the app-setup workflow)
- HPA (handled by the app-setup workflow)
- Sensitive config (handled by the existing deploy sh scripts)
- Client certs (handled by the existing deploy sh scripts)
- Hosts config (handled by the existing deploy sh scripts)

## How to do customize the auth config of an application?

The auth config base template is located at `config-content/base/standard/auth.yaml.tpl`

### Roles

#### Disable a default role

For example, to disable/remove the `super` role for `currency-exchange`, set `.Values.configs.standard.auth.roles.super.defaultRoutes.enabled` to `false` in `values/app-specific/currency-exchange/cp.yaml`.

#### Add additional routes for a default role

For example, to add an additional route for the `super` role for `currency-exchange`, create a block file at `config-content/app-specific/standard/currency-exchange/auth/roles/additional-super-role-routes.tpl` with the below content:

```yaml
- queryString:
    explicitResourceId:
      - '*'
  route: POST:/v2/customers/:customerId/currency-exchange
```

#### Add an additional role

For example, to add an additional role for `currency-exchange`, create a block file at `config-content/app-specific/standard/currency-exchange/auth/roles/additional-roles.tpl` with the below content:

```yaml
newRole:
  - route: 'GET:/{{ $appApiVersion }}/{{ $appPathNoun }}/newRoute'
  - route: 'POST:/{{ $appApiVersion }}/{{ $appPathNoun }}/newRoute'
```

### Profiles

#### Disable a profile

For example, to disable/remove the QA client cert profile for `currency-exchange`, set `.Values.configs.standard.auth.profiles.qaClientCert.enabled` to `false` in `values/app-specific/currency-exchange/cp.yaml`.

#### Add an additional profile

For example, to add an additional profile for `currency-exchange`, create a block file at `config-content/app-specific/standard/currency-exchange/auth/profiles/additional-profiles.tpl` with the below content:

```yaml
- certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.newClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.newClientCert.mtlsSubjectName }}'
  right: 'all'
```

Set different environment-specific subject names `.Values.configs.standard.auth.profiles.newClientCert.mtlsSubjectName` in the following environment/app-specific values files:

- `values/app-specific/currency-exchange/cp.dp.yaml`
- `values/app-specific/currency-exchange/cp.test.yaml`
- `values/app-specific/currency-exchange/cp.ote.yaml`
- `values/app-specific/currency-exchange/cp.prod.yaml`

## How to make Helm adopt existing Kubernetes resources that were not installed with Helm?

The following label and annotations need to be added to existing resources before Helm can start managing them:

```bash
kubectl label $resourceName app.kubernetes.io/managed-by=Helm
kubectl annotate $resourceName meta.helm.sh/release-name=$helmReleaseName
kubectl annotate $resourceName meta.helm.sh/release-namespace=default
```

To adopt Kubernetes resources installed by the legacy bash-based deployment process (already integrated into the new deployment process):

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
