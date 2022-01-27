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
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.log.enabled (ne (required ".Values.app.frameworkType required!" .Values.app.frameworkType) "nodejs") }}
{{- $r }}
{{- end }}

{{/*
Check if standard prometheus config enabled
*/}}
{{- define "commerce-app-v2.configs.standard.prometheus.enabled" }}
{{- $r := and .Values.configs.standard.enabled .Values.configs.standard.prometheus.enabled }}
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

{{/*
Check if livenessProbe path is presented
*/}}
{{- define "commerce-app-v2.deployment.livenessProbe.path.exists" }}
  {{- $r := false -}}
  {{- if .Values.deployment.livenessProbe -}}
    {{- if .Values.deployment.livenessProbe.path -}}
      {{- $r = true -}}
    {{- end -}}
  {{- end -}}
  {{- $r -}}
{{- end }}
