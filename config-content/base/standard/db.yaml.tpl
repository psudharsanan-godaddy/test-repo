{{- $dbName := required ".Values.configs.standard.db.name required!" .Values.configs.standard.db.name }}
{{- $dbcpConfigOverride := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "db" "blockName" "dbcp-config-override") .) }}
{{- $connectionTtlEnabled := required ".Values.configs.standard.db.connectionTtlEnabled required!" .Values.configs.standard.db.connectionTtlEnabled -}}
db_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.DbActiveEndpoint %>:<%= data.DbPort %>/{{ $dbName }}",
    "user": "<%= data.DbUsername %>",
    {{- if empty $dbcpConfigOverride }}
    "dbcpConfig": {
      "maxTotal": 30,
      "maxWaitMillis": 2000,
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $dbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
db_ro_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.DbReaderEndpoint %>:<%= data.DbPort %>/{{ $dbName }}",
    "user": "<%= data.DbUsername %>",
    {{- if empty $dbcpConfigOverride }}
    "dbcpConfig": {
      "maxTotal": 30,
      "maxWaitMillis": 2000,
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $dbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
db_rw_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.DbWriterEndpoint %>:<%= data.DbPort %>/{{ $dbName }}",
    "user": "<%= data.DbUsername %>",
    {{- if empty $dbcpConfigOverride }}
    "dbcpConfig": {
      "maxTotal": 30,
      "maxWaitMillis": 2000,
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $dbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
{{- if .Values.configs.standard.queryDb.enabled }}
{{- $queryDbName := required ".Values.configs.standard.queryDb.name required!" .Values.configs.standard.queryDb.name }}
{{- $queryDbcpConfigOverride := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "db" "blockName" "query-dbcp-config-override") .) }}
query_db_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.QueryDbActiveEndpoint %>:<%= data.QueryDbPort %>/{{ $queryDbName }}",
    "user": "<%= data.QueryDbUsername %>",
    {{- if empty $queryDbcpConfigOverride }}
    "dbcpConfig": {
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $queryDbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
query_db_ro_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.QueryDbActiveReaderEndpoint %>:<%= data.QueryDbPort %>/{{ $queryDbName }}",
    "user": "<%= data.QueryDbUsername %>",
    {{- if empty $queryDbcpConfigOverride }}
    "dbcpConfig": {
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $queryDbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
query_db_rw_config.json: |-
  {
    "driver": "com.mysql.cj.jdbc.Driver",
    "url": "jdbc:mysql://<%= data.DbQueryDbWriterEndpoint %>:<%= data.QueryDbPort %>/{{ $queryDbName }}",
    "user": "<%= data.QueryDbUsername %>",
    {{- if empty $queryDbcpConfigOverride }}
    "dbcpConfig": {
      {{- if $connectionTtlEnabled }}
      "maxConnLifetimeMillis": 300000,
      {{- end }}
      "connectionProperties": "useSSL=true;requireSSL=true;"
    }
    {{- else }}
    {{- $queryDbcpConfigOverride | nindent 4 }}
    {{- end }}
  }
{{- end }}
