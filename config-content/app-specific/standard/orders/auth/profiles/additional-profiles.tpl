{{- $env := required ".Values.env required!" .Values.env }}
- jwtAuth: none
  jwtType: idp
  matchCustomerIdTo: customerId
  right: tempCustomer
- jwtAuth: basic
  jwtMaxHoursAge: 12
  jwtType: idp
  matchCustomerIdTo: customerId
  right: customer
- jwtAuth: e2s
  jwtMaxHoursAge: 2
  jwtType: idp
  matchCustomerIdTo: customerId
  right: customer
- jwtAuth: s2s
  jwtMaxHoursAge: 2
  jwtType: idp
  matchCustomerIdTo: customerId
  right: customer
- jwtAuth: e2s2s
  jwtMaxHoursAge: 2
  jwtType: idp
  matchCustomerIdTo: customerId
  right: customer
- jwtAuth: basic
  jwtGroup: C3-Tier0
  jwtMaxHoursAge: 2
  jwtType: jomax
  right: refundTool
- jwtAuth: basic
  jwtGroup: C3-Tier1
  jwtMaxHoursAge: 2
  jwtType: jomax
  right: refundTool
- jwtAuth: basic
  jwtGroup: C3-Tier2
  jwtMaxHoursAge: 2
  jwtType: jomax
  right: refundTool
- jwtAuth: basic
  jwtGroup: C3-Tier3
  jwtMaxHoursAge: 2
  jwtType: jomax
  right: refundTool
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.ckpClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtMaxHoursAge: 24
  jwtType: cert
  right: journalOnly
{{- if not (eq $env "ote") }}
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.crmClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: crmOnly
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.legalClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: legalOnly
{{- end }}
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.domainsClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: domainsOnly
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.domainsRegistrarClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.domainsRegistrarClientCert.right }}'
{{- if eq $env "prod" }}
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.domainsRegistrarClientCert2.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.domainsRegistrarClientCert2.right }}'
{{- end }}
{{- if not (eq $env "ote") }}
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.fraudAppsClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: fraudApps
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.ipeClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtType: cert
  right: ipeOnly
{{- end }}
{{- if eq $env "prod" }}
- certificateSubjectName: '{{ default "VAR_NOT_SET" .Values.configs.standard.auth.profiles.spaqPollingClientCert.jwtSubjectName }}'
  jwtAuth: basic
  jwtMaxHoursAge: 24
  jwtType: cert
  right: readOnly
{{- end }}
