{{/*
Check if standard write-able volume/mount is enabled
*/}}
{{- define "commerce-app-v2.volumes.standard.writeableVol.enabled" }}
{{- $r := and  .Values.deployment.enabled .Values.deployment.volumes.writeableVol.enabled }}
{{- $r }}
{{- end }}

{{/*
Set standard write-able volume/mount directory
*/}}
{{- define "commerce-app-v2.volumes.standard.writeableVol.appMountPath" }}
{{- $path := required ".Values.deployment.volumes.writeableVol.appMountPath required!" (trimAll " " .Values.deployment.volumes.writeableVol.appMountPath) }}
{{- $valid := and (hasPrefix "/" $path) (ne $path "/") }}
{{- if not $valid }}
{{- fail ( cat "Invalid value for .Values.deployment.volumes.writeableVol.appMountPath: "  $path ) }}
{{- end }}
{{- print $path }}
{{- end }}

{{/*
Set standard write-able volume size
Possible values: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#setting-requests-and-limits-for-local-ephemeral-storage
This should be set to a very modest value.  Just enough for small temporary files to be stored.  Exceptions for larger storages should be handled on a one-off case basis.
This storage mechanism is not for java memory dumps.  Sizes large enough for memory dumps or core dumps should only be enabled in dev and test.
*/}}
{{- define "commerce-app-v2.volumes.standard.writeableVol.size" }}
{{- $storageSize := required ".Values.deployment.volumes.writeableVol.storageSize required!" (trimAll " " .Values.deployment.volumes.writeableVol.storageSize) }}
{{- printf $storageSize }}
{{- end }}

{{/*
Check if standard app config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.app.enabled" }}
{{- $r := and  .Values.configs.standard.enabled .Values.configs.standard.app.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard auth config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.auth.enabled" }}
{{- $configEnabled := and  .Values.configs.standard.enabled .Values.configs.standard.auth.enabled }}
{{- $r := and $configEnabled (or (eq .Values.app.type "service") (eq .Values.app.type "reader"))  }}
{{- $r }}
{{- end }}

{{/*
Check if standard classicDb config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.classicDb.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.classicDb.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard crypto config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.crypto.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.crypto.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard db config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.db.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.db.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard log config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.log.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.log.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard prometheus config enabled for metrics collection
*/}}
{{- define "commerce-app-v2.configs.standard.prometheus.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.prometheus.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if prometheus agent is enabled - This is only needed by Apps exporting metrics through JMX
*/}}
{{- define "commerce-app-v2.configs.standard.prometheusAgent.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.prometheusAgent.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard clientCert config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.clientCert.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.clientCert.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard hosts config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.hosts.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.hosts.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard pki config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.pki.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.pki.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard sensitive config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.sensitive.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.sensitive.enabled }}
{{- $r }}
{{- end }}

{{/*
Check if standard tls config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.tls.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.tls.enabled }}
{{- $r }}
{{- end }}
