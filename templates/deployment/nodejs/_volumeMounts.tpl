{{- define "commerce-app-v2.deployment.nodejs.volumeMounts" -}}
{{- $writableVolEnabled := include "commerce-app-v2.volumes.standard.writableVol.enabled" . | include "strToBool" }}
{{- $writableVolMountPath := include "commerce-app-v2.volumes.standard.writableVol.appMountPath" . }}
{{- if $writableVolEnabled }}
- name: writable-volume
  mountPath: "{{ $writableVolMountPath }}"
{{- end }}
{{- end }}
