HOSTNAME: {{ required ".Values.configs.standard.app.hostname required!" .Values.configs.standard.app.hostname }}
ALLOWED_AD_GROUPS: ["Dev-eCommerce-APIs"]
ATHENA:
    MAX_ATTEMPTS: 10
    ATTEMPT_INTERVAL_IN_MS: 1000
    DATABASE: "s3_glue_database"
    TABLE: "entitlements_journal"
    OUTPUT_LOCATION: '{{ required ".Values.configs.standard.app.athena.outputLocation required!" .Values.configs.standard.app.athena.outputLocation }}'
    REGION: '{{ required ".Values.configs.standard.app.athena.region required!" .Values.configs.standard.app.athena.region }}'
