{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "commerce-app-v2.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "commerce-app-v2.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "commerce-app-v2.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create resource name given the resource name infix and the branch name.

The generated resource name will be:
- "currency-exchange-auth-config" if .Values.deploymentSuffix is ``
- "currency-exchange-auth-config--a13b852" if .Values.deploymentSuffix is `--a13b852`
- "currency-exchange-cacert" if .Values.deploymentSuffix is `--a13b852` but .useBranchAgnosticName is true

Params:
- .Values.app.name required e.g. `currency-exchange`
- .resourceNameInfix required e.g. `auth-config`
- .Values.deploymentSuffix optional e.g. `--a13b852`
- .useBranchAgnosticName optional e.g. true, defaults to false
*/}}
{{- define "commerce-app-v2.resourceName" -}}
{{- $appName := required ".Values.app.name required!" .Values.app.name }}
{{- $resourceNameInfix := required ".resourceNameInfix required!" .resourceNameInfix }}
{{- $useBranchAgnosticName := default false .useBranchAgnosticName }}
{{- $deploymentSuffix := default "" .Values.deploymentSuffix }}
{{- if $useBranchAgnosticName }}
{{- $deploymentSuffix = "" }}
{{- end }}
{{- printf "%s%s%s" $appName $resourceNameInfix $deploymentSuffix | replace "+" "_"  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the container image repository for a commerce app
*/}}
{{- define "commerce-app-v2.containerImageRepository" -}}
{{- $awsAccount := required ".Values.awsAccount required!" .Values.awsAccount }}
{{- $awsRegion := required ".Values.awsRegion required!" .Values.awsRegion }}
{{- $appArtifactId := required ".Values.app.artifactId required!" .Values.app.artifactId }}
{{- printf "%s.dkr.ecr.%s.amazonaws.com/commerce-platform/com.godaddy.commerce.%s" $awsAccount $awsRegion $appArtifactId }}
{{- end }}

{{/*
Create branch-specific app name.

The generated resource name will be:
- "currency-exchange" if .Values.deploymentSuffix is ``
- "currency-exchange--a13b852" if .Values.deploymentSuffix is `--a13b852`

Params:
- .Values.app.name required e.g. `currency-exchange`
- .Values.deploymentSuffix optional e.g. `--a13b852` or ``
*/}}
{{- define "commerce-app-v2.branchSpecificAppName" -}}
{{- $appName := required ".Values.app.name required!" .Values.app.name }}
{{- $deploymentSuffix := default "" .Values.deploymentSuffix }}
{{- printf "%s%s" $appName $deploymentSuffix | replace "+" "_"  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "commerce-app-v2.labels" -}}
helm.sh/chart: {{ include "commerce-app-v2.chart" . | quote }}
{{ include "commerce-app-v2.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
ecomm/app-branch: {{ default "master" .Values.appBranch | quote }}
ecomm/helm-chart-branch: {{ default "master" .Values.helmChartBranch | quote }}
ecomm/cd-jobs-branch: {{ default "master" .Values.cdJobsBranch | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "commerce-app-v2.selectorLabels" -}}
app.kubernetes.io/name: {{ include "commerce-app-v2.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "commerce-app-v2.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "commerce-app-v2.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Load and render config file content

Params:
- .Values.app.name required e.g. `currency-exchange`
- .configType required e.g. `auth`,
  the value needs to match the folder structure:
  config-content/base/<appFrameworkfType>/<configType>.<originalConfigFileExtension>.tpl
- .appFrameworkType optional e.g. `vertx`, defaults to `standard`
- .originalConfigFileExtension optional e.g. `.conf`, defaults to `.json`
*/}}
{{- define "commerce-app-v2.configFileContent" -}}
{{- $appName := required ".Values.app.name required!" .Values.app.name }}
{{- $configType := required ".configType required!" .configType }}
{{- $appFrameworkType := default "standard" .appFrameworkType }}
{{- $originalConfigFileExtension := default ".json" .originalConfigFileExtension }}
{{- $configFilePath := printf "config-content/base/%s/%s%s.tpl" $appFrameworkType $configType $originalConfigFileExtension }}
{{- $templateFileContent := .Files.Get $configFilePath }}
{{- if empty $templateFileContent }}
{{- fail "Config file template does not exist!"}}
{{- end }}
{{- tpl $templateFileContent . }}
{{- end }}

{{/*
Load and render app-specific config block template

Params:
- .Values.app.name required e.g. `currency-exchange`
- .blockName required e.g. `additional-roles`
- .configType required e.g. `auth`,
  the value needs to match the folder structure:
  config-content/app-specific/<appFrameworkfType>/<appName>/<configType>/<blockName>.tpl
- .appFrameworkType optional e.g. `vertx`, defaults to `standard`
*/}}
{{- define "commerce-app-v2.appSpecificConfigBlock" -}}
{{- $appName := required ".Values.app.name required!" .Values.app.name }}
{{- $configType := required ".configType required!" .configType }}
{{- $blockName := required ".blockName required!" .blockName }}
{{- $appFrameworkType := default "standard" .appFrameworkType }}
{{- $blockFilePath := printf "config-content/app-specific/%s/%s/%s/%s.tpl" $appFrameworkType $appName $configType $blockName }}
{{- $blockFileContent := .Files.Get $blockFilePath }}
{{- if not (empty $blockFileContent) }}
{{- tpl $blockFileContent . | trim -}}
{{- end }}
{{- end }}

{{/*
Create the number of replica of a deployment

For readers, only return 1 if the region is the current primary region and the .Values.deploymentSuffix is an empty string
otherwise return 0

For services, use the value provided at .Values.deployment.numberOfReplicas
*/}}
{{- define "commerce-app-v2.deploymentNumberOfReplicas" -}}
{{- $awsRegion := required ".Values.awsRegion required!" .Values.awsRegion }}
{{- $currentPrimaryRegion := required ".Values.currentPrimaryRegion required!" .Values.currentPrimaryRegion }}
{{- $clusterSide := required ".Values.clusterSide required!" .Values.clusterSide }}
{{- $liveClusterSide := required ".Values.liveClusterSide required!" .Values.liveClusterSide }}
{{- $appType := required ".Values.app.type required!" .Values.app.type }}
{{- if eq $appType "reader" }}
{{- $deploymentSuffix := default "" .Values.deploymentSuffix }}
{{- ternary 1 0 (and (eq $awsRegion $currentPrimaryRegion) (eq $clusterSide $liveClusterSide) (eq $deploymentSuffix "")) }}
{{- else }}
{{- required ".Values.deployment.numberOfReplicas required!" .Values.deployment.numberOfReplicas }}
{{- end }}
{{- end }}

{{/*
Create the resources content of a container
*/}}
{{- define "commerce-app-v2.deploymentResources" -}}
{{- $serviceSize := required ".Values.app.size required!" .Values.app.size }}
{{- $requestCpu := required ".Values.deployment.resources.requests.cpu required!" .Values.deployment.resources.requests.cpu }}
{{- $requestMemory := "64Mi" }}
{{- $limitCpu := required ".Values.deployment.resources.limits.cpu required!" .Values.deployment.resources.limits.cpu }}
{{- $limitMemory := "1Gi" }}
{{- if eq $serviceSize "SMALL" }}
{{- $requestMemory = "0.5Gi" }}
{{- $limitMemory = "0.75Gi" }}
{{- else if eq $serviceSize "MEDIUM" }}
{{- $requestMemory = "0.75Gi" }}
{{- $limitMemory = "1Gi" }}
{{- else if eq $serviceSize "LARGE" }}
{{- $requestMemory = "1.5Gi" }}
{{- $limitMemory = "2Gi" }}
{{- else }}
{{- fail ".Values.app.size needs to be one of: SMALL, MEDIUM, and LARGE!" }}
{{- end -}}
requests:
  cpu: {{ $requestCpu | quote }}
  memory: {{ $requestMemory | quote }}
limits:
  cpu: {{ $limitCpu | quote }}
  memory: {{ $limitMemory | quote }}
{{- end }}

{{/*
Create JAVA_OPTS value based on .Values.app.size
*/}}
{{- define "commerce-app-v2.javaOpts" -}}
{{- $serviceSize := required ".Values.app.size required!" .Values.app.size }}
{{- $javaHeapSize := "320M" }}
{{- if eq $serviceSize "SMALL" }}
{{- $javaHeapSize = "320M" }}
{{- else if eq $serviceSize "MEDIUM" }}
{{- $javaHeapSize = "512M" }}
{{- else if eq $serviceSize "LARGE" }}
{{- $javaHeapSize = "1G" }}
{{- else }}
{{- fail ".Values.app.size needs to be one of: SMALL, MEDIUM, and LARGE!" }}
{{- end -}}
{{- $javaOptions := printf "-Xms%s -Xmx%s" $javaHeapSize $javaHeapSize }}
{{- if .Values.app.java -}}
{{- if .Values.app.java.options -}}
{{- $javaOptions = printf "-Xms%s -Xmx%s %s" $javaHeapSize $javaHeapSize .Values.app.java.options }}
{{- end -}}
{{- end -}}
{{- $javaOptions -}}
{{- end }}


{{- define "strToBool" -}}
    {{- $output := "" -}}
    {{- if or (eq . "true") (eq . "yes") (eq . "on") -}}
        {{- $output = "1" -}}
    {{- end -}}
    {{ $output }}
{{- end -}}
