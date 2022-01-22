package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class VolumeMount {

  private String name;
  private String mountPath;

  public static VolumeMount of(String name, String mountPath) {
    VolumeMount volumeMount = new VolumeMount();
    volumeMount.setName(name);
    volumeMount.setMountPath(mountPath);
    return volumeMount;
  }
}
