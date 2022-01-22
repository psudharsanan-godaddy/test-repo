global_labels: &labels
  application: "{{ .Values.app.name }}"

startDelaySeconds: 0
#username:
#password:
#ssl: false
lowercaseOutputName: false
lowercaseOutputLabelNames: false
whitelistObjectNames: [ "java.lang:*", "java.lang:type=Memory", "vertx:*" ]
#blacklistObjectNames: [ ]
rules:
  - pattern: 'vertx<name=(\w+)><>Value: (.*)'
    name: $1
    value: $2
    labels: {
      << : *labels
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name=(\w+)><>(.*): (.*)'
    name: $1_$2
    value: $3
    labels: {
      << : *labels
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name=(\w+)\.exception\.(.*)><>(.*): (.*)'
    name: $1_$3
    value: $4
    labels: {
      << : *labels,
      exception: $2,
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name=(.*)\.exception\.(.*)\.index\.(.*)\.phi\.(.*), type=gauges><>Value: (.*)'
    name: $1_$4
    value: $5
    labels: {
      << : *labels,
      exception: $2,
      index: $3,
      quantile: $4
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name=(.*)\.exception\.(.*)\.index\.(.*), type=timers><>(.*): (.*)'
    name: $1_$4
    value: $5
    labels: {
      << : *labels,
      exception: $2,
      index: $3
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name=(.*)\.pool_name\.(.*)\.pool_type\.(.*)><>(\w+): (.*)'
    name: $1_$4
    value: $5
    labels: {
      <<: *labels,
      pool_name: $2,
      pool_type: $3
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name="(.*)\.code\.(.*)\.local\.(.*)\.method\.(.*)"><>(\w+): (.*)'
    name: $1_$5
    value: $6
    labels: {
      <<: *labels,
      code: $2,
      local: $3,
      method: $4
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name="(.*)\.local\.(.*)"><>(\w+): (.*)'
    name: $1_$3
    value: $4
    labels: {
      <<: *labels,
      local: $2
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name="(.*)\.closed\.(.*)\.httpStatusCode\.(.*)\.phi\.(.*)\.route\.(.*)"><>(\w+): (.*)'
    name: $1_$6
    value: $7
    labels: {
      <<: *labels,
      closed: $2,
      http_status_code: $3,
      quantile: $4,
      route: $5
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'vertx<name="(.*)\.closed\.(.*)\.httpStatusCode\.(.*)\.route\.(.*)"><>(\w+): (.*)'
    name: $1_$5
    value: $6
    labels: {
      <<: *labels,
      closed: $2,
      http_status_code: $3,
      route: $4
    }
    help: "vertx metric $1"
    type: GAUGE

  - pattern: 'java.lang<type=(\w+), name=(.*)><>(\w+): (.*)'
    name: java_lang_$1_$3
    value: $4
    labels: {
      <<: *labels,
      name: $2
    }
    help: "java.lang metric $1 $3"
    type: GAUGE

  - pattern: 'java.lang<type=(\w+)><>(\w+): (.*)'
    name: java_lang_$1_$2
    value: $3
    labels: {
      <<: *labels
    }
    help: "java.lang metric $1"
    type: GAUGE

  - pattern: 'java.lang<type=Memory><(.*)>(.*): (.*)'
    name: java_lang_memory_$1_$2
    value: $3
    labels: {
      <<: *labels,
    }
    help: "java.lang memory $1 $2"
    type: GAUGE
