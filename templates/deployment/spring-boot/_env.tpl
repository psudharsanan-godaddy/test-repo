{{- define "commerce-app-v2.deployment.spring-boot.env" }}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $springConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
- name: METRICS_PORT
  value: "{{ required ".Values.deployment.prometheus.port required!" .Values.deployment.prometheus.port }}"
- name: JAVA_OPTS
  value: "{{ include "commerce-app-v2.javaOpts" . }}"
- name: ENABLE_JMX
  value: "{{ required ".Values.jmx.enabled required!" .Values.jmx.enabled }}"
{{- if $springConfigEnabled }}
- name: SPRING_CONFIG_PATH
  value: "{{ $mountPath }}/spring-boot-application-config/"
{{- end }}
{{- if  $loggingConfigEnabled }}
- name: SPRING_LOGGING_CONFIG_FILE
  value: "{{ $mountPath }}/spring-boot-logging-config/logback-spring.xml"
{{- end }}
{{- end }}