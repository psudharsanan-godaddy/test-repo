{{- $loggingEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.enabled" . | include "strToBool" }}
{{- $loggingLogbookEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.logbook.enabled" . | include "strToBool" }}
{{- $appFrameworkType := "spring-boot" }}
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

  #BEGIN: additional-spring config
{{ include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "application" "blockName" "additional-spring" "appFrameworkType" $appFrameworkType) .) | indent 2}}
  #END: additional-spring config

#Server
server:
  port: 8443
  #BEGIN: additional-server config
{{ include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "application" "blockName" "additional-server" "appFrameworkType" $appFrameworkType) .) | indent 2}}
  #END: additional-server config

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
    root: {{ .type | default "CONSOLE" }}
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
      {{- if .loogbook.obfuscate }}
      {{- if .loogbook.obfuscate.headers }}
      {{- range $headerName := .loogbook.obfuscate.headers }}
      - {{ $headerName }}
      {{- end }}
      {{- end }}
      {{- end }}
    parameters:
      - access_token
      - password
      {{- if .loogbook.obfuscate }}
      {{- if .loogbook.obfuscate.parameters }}
      {{- range $parameterName := .loogbook.obfuscate.parameters }}
      - {{ $parameterName }}
      {{- end }}
      {{- end }}
      {{- end }}
  write:
    max-body-size: -1
{{- end }}
{{- end }}
{{- end }}

#BEGIN: additional-custom config
{{ include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "application" "blockName" "additional-custom" "appFrameworkType" $appFrameworkType) .) | indent 0}}
#END: additional-custom config