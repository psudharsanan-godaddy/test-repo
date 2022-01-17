{{/*
Check if spring-boot application config is enabled.
*/}}
{{- define "commerce-app-v2.configs.spring-boot.application.enabled" }}
  {{- $r := false -}}
  {{- $frameworkEnabled := eq .Values.app.frameworkType "spring-boot" -}}
  {{- if $frameworkEnabled -}}
    {{- if .Values.configs.springBoot -}}
      {{- if .Values.configs.springBoot.enabled -}}
        {{- if .Values.configs.springBoot.application -}}
          {{- if .Values.configs.springBoot.application.enabled -}}
            {{- $r = true -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $r -}}
{{- end }}

{{/*
Check if spring logging config is enabled.
*/}}
{{- define "commerce-app-v2.configs.spring-boot.application.logging.enabled" }}
  {{- $r := false -}}
  {{- $applicationEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" -}}
  {{- if $applicationEnabled -}}
    {{- if .Values.configs.springBoot.application.logging -}}
      {{- $r = true -}}
    {{- end -}}
  {{- end -}}
  {{- $r -}}
{{- end }}

{{/*
Check if spring logbook logging config is enabled.
*/}}
{{- define "commerce-app-v2.configs.spring-boot.application.logging.logbook.enabled" }}
  {{- $r := false -}}
  {{- $loggingEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" -}}
  {{- if $loggingEnabled -}}
    {{- if .Values.configs.springBoot.application.logging.loogbook -}}
      {{- $r = true -}}
    {{- end -}}
  {{- end -}}
  {{- $r -}}
{{- end }}

