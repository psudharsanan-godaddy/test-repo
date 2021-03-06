{{- define "commerce-app-v2.deployment.vertx.env" -}}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $standardAppConfig := include "commerce-app-v2.configs.standard.app.enabled" . | include "strToBool" }}
# ref: https://confluence.godaddy.com/display/VM/CRITICAL+-+log4j+2.x+RCE#CRITICALlog4j2.xRCE-RemediationSteps
- name: LOG4J_FORMAT_MSG_NO_LOOKUPS
  value: "true"
- name: VERTX_ENV
  value: "{{ required ".Values.vertxEnv required!" .Values.vertxEnv }}"
- name: METRICS_PORT
  value: "{{ required ".Values.deployment.prometheus.port required!" .Values.deployment.prometheus.port }}"
- name: JAVA_OPTS
  value: "{{ include "commerce-app-v2.javaOpts" . }}"
- name: ENV_SPECIFIC_IMAGE
  value: "NO"
- name: ENABLE_JMX
  value: "{{ required ".Values.jmx.enabled required!" .Values.jmx.enabled }}"
{{- if $standardAppConfig }}
- name: VERTX_CONF
  value: "-conf {{ $mountPath }}/app/config.json"
{{- end }}
{{- end }}
