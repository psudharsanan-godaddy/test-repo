journalJob:
    jobFrequency: PT1S
    workerThreads: 10
    howManyToGet: 200

recoveryJob:
    jobFrequency: PT30S
    workerThreads: 5
    howManyToGet: 200
    retryRate: PT30S
    maxRetryAge: P1D

journalExportConfig:
    freshnessPeriod: P30D
    s3ExportConfig:
        region: '{{ .Values.configs.standard.app.journalExportConfig.s3ExportConfig.awsRegion }}'
        bucketName: '{{ .Values.configs.standard.app.journalExportConfig.s3ExportConfig.bucketName }}'
