- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.pricingAppClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: readOnly
