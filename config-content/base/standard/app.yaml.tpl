{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
{{- $sensitiveConfigEnabled := include "commerce-app-v2.configs.standard.sensitive.enabled" . | include "strToBool" }}
APP_NOUN: '{{ .Values.app.name }}'
AUTH_CONFIG_PATH: '{{ $mountPath }}/auth/auth-config.json'
CLASSIC_DB_CONFIG_PATH: '{{ $mountPath }}/classic-db/classic_db_config.json'
BONSAI_DB_CONFIG_PATH: '{{ $mountPath }}/bonsai-db/bonsai_db_config.json'
ORION_DB_CONFIG_PATH: '{{ $mountPath }}/orion-db/orion_db_config.json'
CRYPTO_CONFIG_PATH: '{{ $mountPath }}/crypto/crypto_config.json'
CRYPTO_MODE: 'LOCAL'
DB_CONFIG_PATH: '{{ $mountPath }}/db/db_config.json'
DB_RO_CONFIG_PATH: '{{ $mountPath }}/db/db_ro_config.json'
ENABLE_AUTH: {{ required ".Values.vertx.enableAuth required!" .Values.vertx.enableAuth }}
ENABLE_JWT: {{ required ".Values.vertx.enableJwt required!" .Values.vertx.enableJwt }}
ENABLE_SECURITY_LOGGING: {{ required ".Values.vertx.enableSecurityLogging required!" .Values.vertx.enableSecurityLogging }}
ENABLE_TLS: {{ required ".Values.vertx.enableTls required!" .Values.vertx.enableTls }}
ENV_TYPE: '{{ required ".Values.envType required!" .Values.envType }}'
HOSTS_CONFIG_PATH: '{{ $mountPath }}/hosts/config.json'
http.port: 8443
MAX_EVENT_LOOP_EXECUTE_TIME: 10000000000
PAYMENT_DETOKENIZATION_URI: 'http://payments-detokenization-service:8080'
PAYMENT_GATEWAYS_URI: 'http://payment-gateways-service:8080'
PAYMENT_INSTRUMENTS_URI: 'http://payment-instruments-service:8080'
QUERY_DB_CONFIG_PATH: '{{ $mountPath }}/db/query_db_config.json'
QUERY_DB_RO_CONFIG_PATH: '{{ $mountPath }}/db/query_db_ro_config.json'
RESOURCE_ID_PATH_PARAM_NAME: '{{ .Values.app.resourceIdPathParamName }}'
REST_VERSION: 'v2'
SELLER_ACCOUNTS_URI: 'http://seller-accounts-service:8080'
SELLER_CONFIG_URI: 'http://seller-configs-service:8080'
SSL_CONTEXT_CONFIG_PATH: '{{ $mountPath }}/pki-context/context-config.json'
TLS_KEYSTORE_PASS: '{{ $mountPath }}/tls/tls_certs_keystore_pass.txt'
TLS_KEYSTORE_PATH: '{{ $mountPath }}/tls/tls_certs_keystore.pkcs12'
{{- if $sensitiveConfigEnabled }}
SENSITIVE_CONFIG_PATH: '{{ $mountPath }}/sensitive/sensitive-config.json'
{{- end }}
#BEGIN: additional-app config
{{ include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "app" "blockName" "additional-app") .) | indent 0}}
#END: additional-app config
