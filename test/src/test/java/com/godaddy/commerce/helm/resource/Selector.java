package com.godaddy.commerce.helm.resource;

public class Selector {

  private ConfigMapVolume matchLabels;

  public ConfigMapVolume getMatchLabels() {
    return matchLabels;
  }

  public void setMatchLabels(ConfigMapVolume value) {
    this.matchLabels = value;
  }
}
