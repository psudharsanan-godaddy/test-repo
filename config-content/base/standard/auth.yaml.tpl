{{- $appPathNoun := required ".Values.app.pathNoun required!" .Values.app.pathNoun }}
{{- $appApiVersion := required ".Values.app.apiVersion required!" .Values.app.apiVersion }}
{{- $resourceIdPathParamName := required ".Values.app.resourceIdPathParamName required!" (printf ":%s" .Values.app.resourceIdPathParamName) }}
{{- $customerIdParamPath := ternary ":ownerId" "customers/:customerId" (eq $appApiVersion "v1") }}
{{- $env := required ".Values.env required!" .Values.env }}
roles:
  {{- $additionalSuperRoleRoutes := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-super-role-routes") .) }}
  {{- $includeSuperRoleDefaultRoutes := required ".Values.configs.standard.auth.roles.super.defaultRoutes.enabled required!" .Values.configs.standard.auth.roles.super.defaultRoutes.enabled }}
  {{- $includeSuperRole := or $includeSuperRoleDefaultRoutes (not (empty $additionalSuperRoleRoutes)) }}
  {{- if $includeSuperRole }}
  super:
    {{- if $includeSuperRoleDefaultRoutes }}
    - route: 'POST:/{{ $appApiVersion }}/{{ $customerIdParamPath }}/{{ $appPathNoun }}'
      queryString:
        explicitResourceId:
          - '*'
    {{- end }}
    {{- ternary "" ($additionalSuperRoleRoutes | nindent 4) (empty $additionalSuperRoleRoutes) }}
  {{- end }}

  {{- $additionalWriteRoleRoutes := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-write-role-routes") .) }}
  {{- $includeWriteRoleDefaultRoutes := required ".Values.configs.standard.auth.roles.write.defaultRoutes.enabled required!" .Values.configs.standard.auth.roles.write.defaultRoutes.enabled }}
  {{- $includeWriteRole := or $includeWriteRoleDefaultRoutes (not (empty $additionalWriteRoleRoutes)) }}
  {{- if $includeWriteRole }}
  write:
    {{- if $includeWriteRoleDefaultRoutes }}
    - route: 'POST:/{{ $appApiVersion }}/{{ $customerIdParamPath }}/{{ $appPathNoun }}'
    - route: 'PUT:/{{ $appApiVersion }}/{{ $customerIdParamPath }}/{{ $appPathNoun }}/{{ $resourceIdPathParamName }}'
    - route: 'DELETE:/{{ $appApiVersion }}/{{ $customerIdParamPath }}/{{ $appPathNoun }}/{{ $resourceIdPathParamName }}'
    {{- end }}
    {{- ternary "" ($additionalWriteRoleRoutes | nindent 4) (empty $additionalWriteRoleRoutes) }}
  {{- end }}

  {{- $additionalReadRoleRoutes := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-read-role-routes") .) }}
  {{- $includeReadRoleDefaultRoutes := required ".Values.configs.standard.auth.roles.read.defaultRoutes.enabled required!" .Values.configs.standard.auth.roles.read.defaultRoutes.enabled }}
  {{- $includeReadRole := or $includeReadRoleDefaultRoutes (not (empty $additionalReadRoleRoutes)) }}
  {{- if $includeReadRole }}
  read:
    {{- if $includeReadRoleDefaultRoutes }}
    - route: 'GET:/{{ $appApiVersion }}/{{ $customerIdParamPath }}/{{ $appPathNoun }}/{{ $resourceIdPathParamName }}'
    {{- end }}
    {{- ternary "" ($additionalReadRoleRoutes | nindent 4) (empty $additionalReadRoleRoutes) }}
  {{- end }}

  {{- $additionalJournalRoleRoutes := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-journal-role-routes") .) }}
  {{- $includeJournalRoleDefaultRoutes := required ".Values.configs.standard.auth.roles.journal.defaultRoutes.enabled required!" .Values.configs.standard.auth.roles.journal.defaultRoutes.enabled }}
  {{- $includeJournalRole := or $includeJournalRoleDefaultRoutes (not (empty $additionalJournalRoleRoutes)) }}
  {{- if $includeJournalRole }}
  journal:
    {{- if $includeJournalRoleDefaultRoutes }}
    - route: 'GET:/{{ $appApiVersion }}/{{ $appPathNoun }}/journal'
      queryString:
        clock:
          - '*'
        limit:
          - '*'
        journalId:
          - '*'
    {{- end }}
    {{- ternary "" ($additionalJournalRoleRoutes | nindent 4) (empty $additionalJournalRoleRoutes) }}
  {{- end }}

  # healthCheck is not allowed to customize
  healthCheck:
    - route: 'GET:/{{ $appApiVersion }}/{{ $appPathNoun }}/healthcheck'
      {{- with .Values.configs.standard.auth.roles.healthCheck.getImpact }}
      impact: {{ . }}
      {{- end }}
    - route: 'POST:/{{ $appApiVersion }}/{{ $appPathNoun }}/healthcheck'
      {{- with .Values.configs.standard.auth.roles.healthCheck.postImpact }}
      impact: {{ . }}
      {{- end }}

  utility:
    # the /ping route is not allowed to customize
    - route: 'GET:/{{ $appApiVersion }}/{{ $appPathNoun }}/ping'
    {{- $additionalUtilityRoleRoutes := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-utility-role-routes") .) }}
    {{- $includeUtilityRoleDefaultRoutes := required ".Values.configs.standard.auth.roles.utility.defaultRoutes.enabled required!" .Values.configs.standard.auth.roles.utility.defaultRoutes.enabled }}
    {{- $utilityRouteInfix := ternary "" (printf "%s/" $appPathNoun) (eq $appApiVersion "v1") }}
    {{- if $includeUtilityRoleDefaultRoutes }}
    - route: 'GET:/{{ $appApiVersion }}/{{ $utilityRouteInfix }}schema'
    - route: 'GET:/{{ $appApiVersion }}/{{ $utilityRouteInfix }}spec'
    {{- end }}
    {{- ternary "" ($additionalUtilityRoleRoutes | nindent 4) (empty $additionalUtilityRoleRoutes) }}

  {{- $additionalRoles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-roles") .) }}
  {{- ternary "" ($additionalRoles | nindent 2) (empty $additionalRoles) }}

rights:
  {{- $additionalAllRightRoles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "rights/additional-all-right-roles") .) }}
  {{- $includeAllRightRoles := required ".Values.configs.standard.auth.rights.all.defaultRoles.enabled required!" .Values.configs.standard.auth.rights.all.defaultRoles.enabled }}
  {{- $includeAllRight := or $includeAllRightRoles (not (empty $additionalAllRightRoles)) }}
  {{- if $includeAllRight }}
  all:
    {{- if $includeSuperRole }}
    - super
    {{- end }}
    {{- if $includeWriteRole }}
    - write
    {{- end }}
    {{- if $includeReadRole }}
    - read
    {{- end }}
    {{- if $includeJournalRole }}
    - journal
    {{- end }}
    - healthCheck
    - utility
    {{- ternary "" ($additionalAllRightRoles | nindent 4) (empty $additionalAllRightRoles) }}
  {{- end }}

  {{- $additionalAdminRightRoles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "rights/additional-admin-right-roles") .) }}
  {{- $includeAdminRightDefaultRoles := required ".Values.configs.standard.auth.rights.admin.defaultRoles.enabled required!" .Values.configs.standard.auth.rights.admin.defaultRoles.enabled }}
  {{- $includeAdminRight := or $includeAdminRightDefaultRoles (not (empty $additionalAdminRightRoles)) }}
  {{- if $includeAdminRight }}
  admin:
    {{- if $includeAdminRightDefaultRoles }}
    {{- if $includeJournalRole }}
    - journal
    {{- end }}
    - healthCheck
    {{- end }}
    {{- ternary "" ($additionalAdminRightRoles | nindent 4) (empty $additionalAdminRightRoles) }}
  {{- end }}

  {{- $additionalReadOnlyRightRoles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "rights/additional-readonly-right-roles") .) }}
  {{- $includeReadOnlyRightDefaultRoles := required ".Values.configs.standard.auth.rights.readOnly.defaultRoles.enabled required!" .Values.configs.standard.auth.rights.readOnly.defaultRoles.enabled }}
  {{- $includeReadOnlyRight := or $includeReadOnlyRightDefaultRoles (not (empty $additionalReadOnlyRightRoles)) }}
  {{- if $includeReadOnlyRight }}
  readOnly:
    {{- if $includeReadOnlyRightDefaultRoles }}
    {{- if $includeReadRole }}
    - read
    {{- end }}
    {{- if $includeJournalRole }}
    - journal
    {{- end }}
    {{- end }}
    {{- ternary "" ($additionalReadOnlyRightRoles | nindent 4) (empty $additionalReadOnlyRightRoles) }}
  {{- end }}

  {{- $additionalUtilityOnlyRightRoles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "rights/additional-utilityonly-right-roles") .) }}
  {{- $includeUtilityOnlyRightDefaultRoles := required ".Values.configs.standard.auth.rights.utilityOnly.defaultRoles.enabled required!" .Values.configs.standard.auth.rights.utilityOnly.defaultRoles.enabled }}
  {{- $includeUtilityOnlyRight := or $includeUtilityOnlyRightDefaultRoles (not (empty $additionalUtilityOnlyRightRoles)) }}
  {{- if $includeUtilityOnlyRight }}
  utilityOnly:
    {{- if $includeUtilityOnlyRightDefaultRoles }}
    - utility
    {{- end }}
    {{- ternary "" ($additionalUtilityOnlyRightRoles | nindent 4) (empty $additionalUtilityOnlyRightRoles) }}
  {{- end }}

  {{- $additionalRights := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "rights/additional-rights") .) }}
  {{- ternary "" ($additionalRights | nindent 2) (empty $additionalRights) }}

profiles:
  {{- if .Values.configs.standard.auth.profiles.ecommClientCert.enabled }}
  {{- $ecommClientCertRight := required ".Values.configs.standard.auth.profiles.ecommClientCert.right required!" .Values.configs.standard.auth.profiles.ecommClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.ecommClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.ecommClientCert.mtlsSubjectName }}'
    right: '{{ $ecommClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.ecommClientCert.jwtSubjectName required!" .Values.configs.standard.auth.profiles.ecommClientCert.jwtSubjectName }}'
    right: '{{ $ecommClientCertRight }}'
  {{- end }}

  # the orchestration client cert is required to be allowed
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ .Values.configs.standard.auth.profiles.ecommOrchOldClientCert.jwtSubjectName }}'
    right: '{{ required ".Values.configs.standard.auth.profiles.ecommOrchClientCert.right required!" .Values.configs.standard.auth.profiles.ecommOrchClientCert.right }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ .Values.configs.standard.auth.profiles.ecommOrchClientCert.jwtSubjectName }}'
    right: '{{ required ".Values.configs.standard.auth.profiles.ecommOrchClientCert.right required!" .Values.configs.standard.auth.profiles.ecommOrchClientCert.right }}'

  {{- if .Values.configs.standard.auth.profiles.legacyPciClientCert.enabled }}
  {{- $legacyPciClientCertRight := required ".Values.configs.standard.auth.profiles.legacyPciClientCert.right required!" .Values.configs.standard.auth.profiles.legacyPciClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyPciClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.legacyPciClientCert.mtlsSubjectName }}'
    right: '{{ $legacyPciClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyPciClientCert.jwtSubjectName required!" .Values.configs.standard.auth.profiles.legacyPciClientCert.jwtSubjectName }}'
    right: '{{ $legacyPciClientCertRight }}'
  {{- end }}

  {{- if .Values.configs.standard.auth.profiles.legacyPciClientCert2.enabled }}
  {{- $legacyPciClientCert2Right := required ".Values.configs.standard.auth.profiles.legacyPciClientCert2.right required!" .Values.configs.standard.auth.profiles.legacyPciClientCert2.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyPciClientCert2.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.legacyPciClientCert2.mtlsSubjectName }}'
    right: '{{ $legacyPciClientCert2Right }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyPciClientCert2.jwtSubjectName required!" .Values.configs.standard.auth.profiles.legacyPciClientCert2.jwtSubjectName }}'
    right: '{{ $legacyPciClientCert2Right }}'
  {{- end }}

  {{- if .Values.configs.standard.auth.profiles.legacyGenClientCert.enabled }}
  {{- $legacyGenClientCertRight := required ".Values.configs.standard.auth.profiles.legacyGenClientCert.right required!" .Values.configs.standard.auth.profiles.legacyGenClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyGenClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.legacyGenClientCert.mtlsSubjectName }}'
    right: '{{ $legacyGenClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.legacyPciClientCert.jwtSubjectName required!" .Values.configs.standard.auth.profiles.legacyGenClientCert.jwtSubjectName }}'
    right: '{{ $legacyGenClientCertRight }}'
  {{- end }}

  {{- if or (eq $env "ote") (eq $env "prod") }}
  {{- if .Values.configs.standard.auth.profiles.adminClientCert.enabled }}
  {{- $adminClientCertRight := required ".Values.configs.standard.auth.profiles.adminClientCert.right required!" .Values.configs.standard.auth.profiles.adminClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.adminClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.adminClientCert.mtlsSubjectName }}'
    right: '{{ $adminClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.adminClientCert.jwtSubjectName required!" .Values.configs.standard.auth.profiles.adminClientCert.jwtSubjectName }}'
    right: '{{ $adminClientCertRight }}'
  {{- end }}
  {{- end }}

  {{- if .Values.configs.standard.auth.profiles.qaClientCert.enabled }}
  {{- $qaClientCertRight := required ".Values.configs.standard.auth.profiles.qaClientCert.right required!" .Values.configs.standard.auth.profiles.qaClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.qaClientCert.mtlsSubjectName }}'
    right: '{{ $qaClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.qaClientCert.jwtSubjectName }}'
    right: '{{ $qaClientCertRight }}'
  {{- end }}

  {{- if or (eq $env "dp") (eq $env "test") }}
  {{- if .Values.configs.standard.auth.profiles.qaToolClientCert.enabled }}
  {{- $qaToolClientCertRight := required ".Values.configs.standard.auth.profiles.qaToolClientCert.right required!" .Values.configs.standard.auth.profiles.qaToolClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.qaToolClientCert.mtlsSubjectName }}'
    right: '{{ $qaToolClientCertRight }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert.jwtSubjectName required!" .Values.configs.standard.auth.profiles.qaToolClientCert.jwtSubjectName }}'
    right: '{{ $qaToolClientCertRight }}'
  {{- end }}

  {{- if .Values.configs.standard.auth.profiles.qaToolClientCert2.enabled }}
  {{- $qaToolClientCert2Right := required ".Values.configs.standard.auth.profiles.qaToolClientCert2.right required!" .Values.configs.standard.auth.profiles.qaToolClientCert.right }}
  - certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert2.mtlsSubjectName required!" .Values.configs.standard.auth.profiles.qaToolClientCert2.mtlsSubjectName }}'
    right: '{{ $qaToolClientCert2Right }}'
  - jwtAuth: basic
    jwtType: cert
    certificateSubjectName: '{{ required ".Values.configs.standard.auth.profiles.qaToolClientCert2.jwtSubjectName required!" .Values.configs.standard.auth.profiles.qaToolClientCert2.jwtSubjectName }}'
    right: '{{ $qaToolClientCert2Right }}'
  {{- end }}
  {{- end }}

  {{- if .Values.configs.standard.auth.profiles.noneCert.enabled }}
  - certificateSubjectName: none
    right: '{{required ".Values.configs.standard.auth.profiles.noneCert.right required!" .Values.configs.standard.auth.profiles.noneCert.right }}'
  {{- end }}

  {{- $additionalProfiles := include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "profiles/additional-profiles") .) }}
  {{- ternary "" ($additionalProfiles | nindent 2) (empty $additionalProfiles) }}
