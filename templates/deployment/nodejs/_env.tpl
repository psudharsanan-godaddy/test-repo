{{- define "commerce-app-v2.deployment.nodejs.env" }}
{{- $writableVolEnabled := include "commerce-app-v2.volumes.standard.writableVol.enabled" . | include "strToBool" }}
{{- $writableVolMountPath := include "commerce-app-v2.volumes.standard.writableVol.appMountPath" . }}
- name: NODE_ENV
  value: {{ required ".Values.nodeEnv required!" .Values.nodeEnv }}
{{- if $writableVolEnabled }}
- name: APP_WRITABLE_DIR
  value: "{{ $writableVolMountPath }}"
{{- end }}
{{- end }}
