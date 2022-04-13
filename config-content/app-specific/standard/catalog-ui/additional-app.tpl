HOSTNAME: {{ required ".Values.configs.standard.app.hostname required!" .Values.configs.standard.app.hostname }}
ENV: {{ required ".Values.configs.standard.app.env required!" .Values.configs.standard.app.env }}
