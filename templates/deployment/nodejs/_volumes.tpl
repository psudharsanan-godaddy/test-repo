{{- define "commerce-app-v2.deployment.nodejs.volumes" }}
{{- $writableVolEnabled := include "commerce-app-v2.volumes.standard.writableVol.enabled" . | include "strToBool" }}
{{- if $writableVolEnabled }}
- name: writable-volume
  emptyDir: {}
{{- end }}
{{- end }}
