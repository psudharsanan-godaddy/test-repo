{{- $mountPath := required ".Values.configs.mountPath required!" .Values.configs.mountPath }}
json:
  config:
    #In order to use properties from json files
    #you have to add prefix to any json property name.
    #If json.config.path contains sub json configs, then after prefix you have to add
    #property name in main json config for example 'json.HOSTS_CONFIG_PATH.SSO.url'
    prefix: "json"
    location-prefix: "file:"
    path: "${CONFIG_PATH:{{- $mountPath -}}/app}/config.json"