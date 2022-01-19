package com.godaddy.commerce.helm.resource;

public class TemplateSpec {

  private Affinity affinity;
  private Container[] containers;
  private long terminationGracePeriodSeconds;
  private Volume[] volumes;

  public Affinity getAffinity() {
    return affinity;
  }

  public void setAffinity(Affinity value) {
    this.affinity = value;
  }

  public Container[] getContainers() {
    return containers;
  }

  public void setContainers(Container[] value) {
    this.containers = value;
  }

  public long getTerminationGracePeriodSeconds() {
    return terminationGracePeriodSeconds;
  }

  public void setTerminationGracePeriodSeconds(long value) {
    this.terminationGracePeriodSeconds = value;
  }

  public Volume[] getVolumes() {
    return volumes;
  }

  public void setVolumes(Volume[] value) {
    this.volumes = value;
  }
}
