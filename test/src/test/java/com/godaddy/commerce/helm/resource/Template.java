package com.godaddy.commerce.helm.resource;

public class Template {

  private TemplateMetadata metadata;
  private TemplateSpec spec;

  public TemplateMetadata getMetadata() {
    return metadata;
  }

  public void setMetadata(TemplateMetadata value) {
    this.metadata = value;
  }

  public TemplateSpec getSpec() {
    return spec;
  }

  public void setSpec(TemplateSpec value) {
    this.spec = value;
  }
}
