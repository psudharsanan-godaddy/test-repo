{{- define "commerce-app-v2.deployment.vertx.volumeMounts" -}}
{{- $optionsEnabled := include "commerce-app-v2.configs.vertx.options.enabled" . | include "strToBool" }}
{{- if $optionsEnabled }}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
- name: vertx-options-secret
  mountPath: "{{ $mountPath }}/vertx-options"
{{- end }}
{{- end }}


