{{- define "commerce-app-v2.deployment.spring-boot.volumes" }}
{{- $applicationEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- $writableVolEnabled := include "commerce-app-v2.volumes.standard.writableVol.enabled" . | include "strToBool" }}
{{- if $applicationEnabled }}
- name: spring-boot-app-config-secret
  secret:
    secretName: {{ include "commerce-app-v2.resourceName" (merge (dict "resourceNameInfix" "-spring-boot-app-config") .) }}
{{- end }}
{{- if $loggingConfigEnabled }}
- name: spring-boot-logging-config-configmap
  configMap:
    name: {{ include "commerce-app-v2.resourceName" (merge (dict "resourceNameInfix" "-spring-boot-logging-config") .) }}
{{- end }}
{{- if $writableVolEnabled }}
- name: writable-volume
  emptyDir: {}
{{- end }}
{{- end }}
