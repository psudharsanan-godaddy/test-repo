{{- $loggingEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- $loggingLogbookEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.logbook.enabled" . | include "strToBool" }}
#Application
application:
  env: "{{ required ".Values.env required!" .Values.env }}"
  generatedAt: "{{ now | date "2006-01-02T15:04:05 MST" }}"
  apiVersion: "{{ .Values.app.apiVersion }}"

#Spring
spring:
  application:
    name: "{{ .Values.app.name }}"
  jackson:
    date-format: "com.fasterxml.jackson.databind.util.ISO8601DateFormat"

#Server
server:
  port: 8443

#Actuator
management:
  endpoints:
    enabled-by-default: false
  endpoint:
    health:
      enabled: true
      show-details: never

{{- with .Values.configs.springBoot.application.logging }}
{{ if $loggingEnabled }}
#Logging
logging:
  appender:
    root: {{ .type }}
{{ if $loggingLogbookEnabled }}
#Zalando logbook
logbook:
  filter:
    enabled: true
  exclude: "{{ .loogbook.exclude | default  "/swagger-ui/**,/v3/api-docs/**,**/ping,**/healthcheck,**/actuator/**,/" }}"
  strategy: default
  obfuscate:
    headers:
      - Authorization
      - X-Secret
      {{- range $headerName := .loogbook.obfuscate.headers }}
      - {{ $headerName }}
      {{- end }}
    parameters:
      - access_token
      - password
      {{- range $parameterName := .loogbook.obfuscate.parameters }}
      - {{ $parameterName }}
      {{- end }}
  write:
    max-body-size: -1
{{- end }}
{{- end }}
{{- end }}