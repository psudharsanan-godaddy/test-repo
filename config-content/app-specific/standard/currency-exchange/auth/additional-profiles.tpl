- jwtAuth: basic
  jwtType: cert
  certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert2.jwtSubjectName required!" .Values.configs.standard.auth.profiles.instoreCreditGatewayClientCert.jwtSubjectName }}'
  right: readOnly
- jwtAuth: basic
  jwtType: cert
  certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert2.jwtSubjectName required!" .Values.configs.standard.auth.profiles.pricingAppClient.jwtSubjectName }}'
  right: all
