{{- define "commerce-app-v2.deployment.spring-boot.volume" }}
{{- $applicationEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- if $applicationEnabled }}
- name: spring-boot-application-config-secret
  secret:
    secretName: {{ include "commerce-app-v2.resourceName" (merge (dict "resourceNameInfix" "-spring-boot-application-config") .) }}
{{- end }}
{{- if $loggingConfigEnabled }}
- name: spring-boot-logging-config-secret
  secret:
    secretName: {{ include "commerce-app-v2.resourceName" (merge (dict "resourceNameInfix" "-spring-boot-logging-config") .) }}
{{- end }}
{{- end }}