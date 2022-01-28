{{- define "commerce-app-v2.deployment.spring-boot.env" }}
{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $springConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.enabled" . | include "strToBool" }}
{{- $loggingConfigEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
# ref: https://confluence.godaddy.com/display/VM/CRITICAL+-+log4j+2.x+RCE#CRITICALlog4j2.xRCE-RemediationSteps
- name: LOG4J_FORMAT_MSG_NO_LOOKUPS
  value: "true"
- name: METRICS_PORT
  value: "{{ required ".Values.deployment.prometheus.port required!" .Values.deployment.prometheus.port }}"
- name: JAVA_OPTS
  value: "{{ include "commerce-app-v2.javaOpts" . }}"
- name: ENABLE_JMX
  value: "{{ required ".Values.jmx.enabled required!" .Values.jmx.enabled }}"
{{- if $springConfigEnabled }}
  #Do not change env name this is specific at least for spring-boot 2.5.*
- name: SPRING_CONFIG_ADDITIONAL_LOCATION
  value: "{{ $mountPath }}/spring-boot-application-config/"
{{- end }}
{{- if  $loggingConfigEnabled }}
  #Do not change env name this is specific at least for spring-boot 2.5.*
- name: LOGGING_CONFIG
  value: "{{ $mountPath }}/spring-boot-logging-config/logback-spring.xml"
{{- end }}
{{- end }}