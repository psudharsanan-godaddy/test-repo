- certificateSubjectName: CN=instore-credit-gateway-icp.client.cp.api.{{ required ".Values.gdDomainEnvPrefix required!" .Values.gdDomainEnvPrefix }}godaddy.com, OU=, O=
  jwtAuth: basic
  jwtType: cert
  right: readOnly
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.pricingAppClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: all
