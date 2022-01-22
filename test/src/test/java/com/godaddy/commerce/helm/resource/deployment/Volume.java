package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class Volume {

  private String name;
  private Secret secret;
  private ConfigMapVolume configMap;

  public static Volume secretVolume(String volumeName, String secretName) {
    Volume volume = new Volume();
    volume.setName(volumeName);
    Secret secret = new Secret();
    volume.setSecret(secret);
    secret.setSecretName(secretName);
    return volume;
  }

  public static Volume configMapVolume(String volumeName, String configMapName) {
    Volume volume = new Volume();
    volume.setName(volumeName);
    ConfigMapVolume configMapVolume = new ConfigMapVolume();
    configMapVolume.setName(configMapName);
    volume.setConfigMap(configMapVolume);
    return volume;
  }

}
