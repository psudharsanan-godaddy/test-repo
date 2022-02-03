{{- define "commerce-app-v2.deployment.nodejs.env" }}
- name: NODE_ENV
  value: {{ required ".Values.nodeEnv required!" .Values.nodeEnv }}
{{- end }}
