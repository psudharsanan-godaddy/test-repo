# FAQ

# Content:

- [What is Helm?](#what-is-helm?)
- [Why using Helm?](#why-using-helm?)
- [How do we organize this Helm chart?](#how-do-we-organize-this-helm-chart?)
- [What resources of an application are NOT managed by this Helm chart?](#what-resources-of-an-application-are-not-managed-by-this-helm-chart?)
- [Writable Volumes](#writable-volumes)
- [How can an application’s auth config be customized?](#how-can-an-application’s-auth-config-be-customized?)
- [How to make Helm adopt existing Kubernetes resources that were not installed with Helm?](#how-to-make-helm-adopt-existing-kubernetes-resources-that-were-not-installed-with-helm?)


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
- ClusterIP and NLB services (handled by the app-setup workflow)
- Route 53/Corp DNS records (handled by the app-setup workflow)
- HPA (handled by the app-setup workflow)
- Sensitive config (handled by the existing deploy sh scripts)
- Client certs (handled by the existing deploy sh scripts)
- Hosts config (handled by the existing deploy sh scripts)

## Writable Volumes

The writable volume support should be used sparingly, as it creates a common vector for security attacks (a writable and executable location on their application).
Applications enabling this feature should understand this risk, and use it only when absolutely necessary.

At the time this support was added, nearly 100 of 113 eComm NES applications are running without this risk.  The following are currently the use-cases for enabling this feature:

- Using Gasket (needed by our two NodeJS user interface applications)
- Using Billsoft's EZTax (only needed by Avalara service)
- Using Elastic's APM jar.  Please note, it is a question whether all of the 3 to 4 installation methods of the Elastic's APM module require the writable directory, but the method we use now does use a writable directory.
- Using Tomcat. The department is currently reviewing whether we should use other Java application servers to remove this use-case.

At the moment only spring-boot or nodejs applications supports writable directory. You can 
enable it by using: `deployment.volumes.writableVol.enabled: true`, most likely you also need to 
enable `deployment.volumes.fsGroup.enabled: true`.

## How can an application’s auth config be customized?

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
