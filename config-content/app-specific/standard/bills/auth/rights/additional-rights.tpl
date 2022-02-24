{{- $env := required ".Values.env required!" .Values.env }}
bgProcessor:
  - read
{{- if not (eq $env "ote") }}
crmOnly:
  - externalRead
{{- end }}
customer:
  - externalRead
domainsRegistrarOnly:
  - read
  - refundWrite
  - utility
  - healthCheck
  - create
  - update
{{- if not (eq $env "ote") }}
fraudApps:
  - create
  - read
  - chargebackWrite
  - update
ipeOnly:
  - read
  - journal
{{- end }}
journalOnly:
  - journal
{{- if not (eq $env "ote") }}
legalOnly:
  - read
{{- end }}
marTechOnly:
  - read
refundTool:
  - create
  - read
  - refundWrite
  - update
request:
  - update
  - create
  - read
  - write
verification:
  - update
  - create
  - read
  - verify
