{{- define "commerce-app-v2.deployment.spring-boot.volumeMounts" -}}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $applicationEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- if $applicationEnabled }}
- name: spring-boot-app-config-secret
  mountPath: "{{ $mountPath }}/spring-boot-app-config"
{{- end }}
{{- if $loggingConfigEnabled }}
- name: spring-boot-logging-config-configmap
  mountPath: "{{ $mountPath }}/spring-boot-logging-config"
{{- end }}
{{- if .Values.app.tmpdir }}
- name: tomcat-tmp-dir
  mountPath: "{{ .Values.app.tmpdir }}"
{{- end }}
{{- end }}
