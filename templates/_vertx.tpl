{{/*
Check if vertx options config is enabled.
*/}}
{{- define "commerce-app-v2.configs.vertx.options.enabled" }}
  {{- $r := false -}}
  {{- $frameworkEnabled := eq .Values.app.frameworkType "vertx" -}}
  {{- if $frameworkEnabled -}}
    {{- if .Values.configs.vertx -}}
      {{- if .Values.configs.vertx.enabled -}}
        {{- if .Values.configs.vertx.options -}}
          {{- if .Values.configs.vertx.options.enabled -}}
            {{- $r = true -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $r -}}
{{- end }}
