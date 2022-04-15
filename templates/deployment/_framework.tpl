{{/* vim: set filetype=mustache: */}}

{{/* Prepare framework specific deployment env */}}
{{- define "commerce-app-v2.deployment.framework.env" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific envs
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.env" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.env" . }}
{{- else if eq .Values.app.frameworkType "nodejs" }}
{{- template "commerce-app-v2.deployment.nodejs.env" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific envs
{{- end }}

{{/* Prepare framework specific deployment volume mounts */}}
{{- define "commerce-app-v2.deployment.framework.volumeMount" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific volume mounts
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.volumeMounts" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.volumeMounts" . }}
{{- else if eq .Values.app.frameworkType "nodejs" }}
{{- template "commerce-app-v2.deployment.nodejs.volumeMounts" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific volume mount end
{{- end }}

{{/* Prepare framework specific deployment volumes */}}
{{- define "commerce-app-v2.deployment.framework.volume" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific volumes
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.volumes" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.volumes" . }}
{{- else if eq .Values.app.frameworkType "nodejs" }}
{{- template "commerce-app-v2.deployment.nodejs.volumes" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific volumes
{{- end }}
