package com.godaddy.commerce.helm.resource;

public class VolumeMount {

  private String name;
  private String mountPath;

  public String getName() {
    return name;
  }

  public void setName(String value) {
    this.name = value;
  }

  public String getMountPath() {
    return mountPath;
  }

  public void setMountPath(String value) {
    this.mountPath = value;
  }
}
