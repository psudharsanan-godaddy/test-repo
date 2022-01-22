{{- define "commerce-app-v2.deployment.vertx.volume" }}
{{- $optionsEnabled := include "commerce-app-v2.configs.vertx.options.enabled" . | include "strToBool" }}
{{- if $optionsEnabled }}
- name: vertx-options-secret
  secret:
    secretName: {{ include "commerce-app-v2.resourceName" (merge (dict "resourceNameInfix" "-vertx-options") .) }}
{{- end }}
{{- end }}