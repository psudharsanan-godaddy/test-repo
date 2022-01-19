package com.godaddy.commerce.helm.resource;

public class SecretResource {

  private String apiVersion;
  private String kind;
  private Metadata metadata;
  private Data data;

  public String getAPIVersion() {
    return apiVersion;
  }

  public void setAPIVersion(String value) {
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

  public Data getData() {
    return data;
  }

  public void setData(Data value) {
    this.data = value;
  }
}


