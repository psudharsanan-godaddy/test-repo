package com.godaddy.commerce.helm.resource;

public class DeploymentResource {

  private String apiVersion;
  private String kind;
  private Metadata metadata;
  private Spec spec;

  public String getApiVersion() {
    return apiVersion;
  }

  public void setApiVersion(String value) {
    this.apiVersion = value;
  }

  public String getKind() {
    return kind;
  }

  public void setKind(String value) {
    this.kind = value;
  }

  public Metadata getMetadata() {
    return metadata;
  }

  public void setMetadata(Metadata value) {
    this.metadata = value;
  }

  public Spec getSpec() {
    return spec;
  }

  public void setSpec(Spec value) {
    this.spec = value;
  }
}


