package com.godaddy.commerce.helm.resource;

import java.util.Map;

public class TemplateMetadata {

  private Map<String, String> labels;
  private Map<String, Object> annotations;

  public Map<String, String> getLabels() {
    return labels;
  }

  public void setLabels(Map<String, String> value) {
    this.labels = value;
  }

  public Map<String, Object> getAnnotations() {
    return annotations;
  }

  public void setAnnotations(Map<String, Object> value) {
    this.annotations = value;
  }
}
