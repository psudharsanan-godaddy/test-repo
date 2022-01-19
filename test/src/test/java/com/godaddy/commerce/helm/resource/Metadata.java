package com.godaddy.commerce.helm.resource;

import java.util.Map;

public class Metadata {

  private String name;
  private Map<String, String> labels;

  public String getName() {
    return name;
  }

  public void setName(String value) {
    this.name = value;
  }

  public Map<String, String> getLabels() {
    return labels;
  }

  public void setLabels(Map<String, String> value) {
    this.labels = value;
  }
}
