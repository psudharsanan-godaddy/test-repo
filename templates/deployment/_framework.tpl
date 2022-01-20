{{/* vim: set filetype=mustache: */}}

{{/* Prepare framework specific deployment env */}}
{{- define "commerce-app-v2.deployment.framework.env" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific envs
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.env" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.env" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific envs
{{- end }}

{{/* Prepare framework specific deployment volume mounts */}}
{{- define "commerce-app-v2.deployment.framework.volumeMount" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific volume mounts
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.volumeMount" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.volumeMount" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific volume mount end
{{- end }}

{{/* Prepare framework specific deployment volumes */}}
{{- define "commerce-app-v2.deployment.framework.volume" -}}
#BEGIN: {{ required ".Values.app.frameworkType required!" .Values.app.frameworkType }} specific volumes
{{- if eq .Values.app.frameworkType "vertx" }}
{{- template "commerce-app-v2.deployment.vertx.volume" . }}
{{- else if eq .Values.app.frameworkType "spring-boot" }}
{{- template "commerce-app-v2.deployment.spring-boot.volume" . }}
{{- end }}
#END: {{ .Values.app.frameworkType }} specific volumes
{{- end }}