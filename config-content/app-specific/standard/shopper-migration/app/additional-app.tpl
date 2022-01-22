{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
SENSITIVE_CONFIG_PATH: '{{- $mountPath }}/sensitive/sensitive-config.json'