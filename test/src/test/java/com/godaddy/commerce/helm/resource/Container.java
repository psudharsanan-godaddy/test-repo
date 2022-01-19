package com.godaddy.commerce.helm.resource;

import java.util.Map;

public class Container {

  private String name;
  private Map<String, Object> lifecycle;
  private String image;
  private String imagePullPolicy;
  private VolumeMount[] volumeMounts;
  private Port[] ports;
  private SecurityContext securityContext;
  private Probe livenessProbe;
  private Probe readinessProbe;
  private Resources resources;
  private Env[] env;

  public String getName() {
    return name;
  }

  public void setName(String value) {
    this.name = value;
  }

  public Map<String, Object> getLifecycle() {
    return lifecycle;
  }

  public void setLifecycle(Map<String, Object> value) {
    this.lifecycle = value;
  }

  public String getImage() {
    return image;
  }

  public void setImage(String value) {
    this.image = value;
  }

  public String getImagePullPolicy() {
    return imagePullPolicy;
  }

  public void setImagePullPolicy(String value) {
    this.imagePullPolicy = value;
  }

  public VolumeMount[] getVolumeMounts() {
    return volumeMounts;
  }

  public void setVolumeMounts(VolumeMount[] value) {
    this.volumeMounts = value;
  }

  public Port[] getPorts() {
    return ports;
  }

  public void setPorts(Port[] value) {
    this.ports = value;
  }

  public SecurityContext getSecurityContext() {
    return securityContext;
  }

  public void setSecurityContext(SecurityContext value) {
    this.securityContext = value;
  }

  public Probe getLivenessProbe() {
    return livenessProbe;
  }

  public void setLivenessProbe(Probe value) {
    this.livenessProbe = value;
  }

  public Probe getReadinessProbe() {
    return readinessProbe;
  }

  public void setReadinessProbe(Probe value) {
    this.readinessProbe = value;
  }

  public Resources getResources() {
    return resources;
  }

  public void setResources(Resources value) {
    this.resources = value;
  }

  public Env[] getEnv() {
    return env;
  }

  public void setEnv(Env[] value) {
    this.env = value;
  }
}
