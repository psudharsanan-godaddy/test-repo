package com.godaddy.commerce.helm.resource;

import java.util.Map;
import javax.management.monitor.StringMonitor;

public class Affinity {

  private Map<String, Object> podAntiAffinity;

  public Map<String, Object> getPodAntiAffinity() {
    return podAntiAffinity;
  }

  public void setPodAntiAffinity(Map<String, Object> value) {
    this.podAntiAffinity = value;
  }
}
