<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <jmxConfigurator/>
  <include resource="org/springframework/boot/logging/logback/defaults.xml"/>
  <include resource="org/springframework/boot/logging/logback/console-appender.xml"/>
{{ if eq .Values.configs.springBoot.application.logging.type "CONSOLE_JSON" }}
  <appender name="CONSOLE_JSON" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="net.logstash.logback.encoder.LogstashEncoder">
      <includeContext>false</includeContext>
      <timeZone>UTC</timeZone>
      <fieldNames>
        <timestamp>timestamp</timestamp>
        <thread>threadName</thread>
        <logger>loggerName</logger>
      </fieldNames>
    </encoder>
  </appender>
{{- end }}

  <!--Properties-->
  <springProperty scope="context" name="rootAppender" source="logging.appender.root"
    defaultValue="{{- .Values.configs.springBoot.application.logging.type | default "CONSOLE" }}"/>
  <springProperty scope="context" name="rootLevel" source="logging.level.root" defaultValue="INFO"/>
  <springProperty scope="context" name="commerceLogLevel" source="logging.level.commerce"
    defaultValue="INFO"/>
  <springProperty scope="context" name="authLogLevel" source="logging.level.auth"
    defaultValue="INFO"/>

  <logger name="com.godaddy.commerce" level="${commerceLogLevel}"/>
  <logger name="com.godaddy.auth.spring.web" level="${authLogLevel}"/>
  <logger name="org.springframework.security.oauth2.server.resource" level="${authLogLevel}"/>

{{- $logBookEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.logbook.enabled" . | include "strToBool" }}
{{ if $logBookEnabled }}
  <!--Payload logging-->
  <logger name="org.zalando.logbook.Logbook" level="ALL" additivity="false">
    <appender-ref ref="${rootAppender}"/>
  </logger>
{{- end }}

{{- $auditLoggingEnabled := include "commerce-app-v2.configs.spring-boot.application.logging.audit.enabled" . | include "strToBool" }}
{{ if $auditLoggingEnabled }}
  <!--Audit logging-->
  <logger name="com.godaddy.commerce.spring.logging.audit.LogAuditEventRepository" level="ALL" additivity="false">
    <appender-ref ref="${rootAppender}"/>
  </logger>
{{- end }}

  <root level="${rootLevel}">
    <appender-ref ref="${rootAppender}"/>
  </root>

</configuration>
