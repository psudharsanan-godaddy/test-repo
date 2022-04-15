{{- define "commerce-app-v2.deployment.spring-boot.volumeMounts" -}}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $applicationEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- $writableVolEnabled := include "commerce-app-v2.volumes.standard.writableVol.enabled" . | include "strToBool" }}
{{- $writableVolMountPath := include "commerce-app-v2.volumes.standard.writableVol.appMountPath" . }}
{{- if $applicationEnabled }}
- name: spring-boot-app-config-secret
  mountPath: "{{ $mountPath }}/spring-boot-app-config"
{{- end }}
{{- if $loggingConfigEnabled }}
- name: spring-boot-logging-config-configmap
  mountPath: "{{ $mountPath }}/spring-boot-logging-config"
{{- end }}
{{- if $writableVolEnabled }}
- name: writable-volume
  mountPath: "{{ $writableVolMountPath }}"
{{- end }}
{{- end }}
