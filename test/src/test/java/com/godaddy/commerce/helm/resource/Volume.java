package com.godaddy.commerce.helm.resource;

public class Volume {

  private String name;
  private Secret secret;
  private ConfigMapVolume configMap;

  public String getName() {
    return name;
  }

  public void setName(String value) {
    this.name = value;
  }

  public Secret getSecret() {
    return secret;
  }

  public void setSecret(Secret value) {
    this.secret = value;
  }

  public ConfigMapVolume getConfigMap() {
    return configMap;
  }

  public void setConfigMap(ConfigMapVolume value) {
    this.configMap = value;
  }
}
