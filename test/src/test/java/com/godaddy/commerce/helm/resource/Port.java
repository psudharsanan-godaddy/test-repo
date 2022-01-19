package com.godaddy.commerce.helm.resource;

public class Port {

  private long containerPort;
  private String protocol;

  public long getContainerPort() {
    return containerPort;
  }

  public void setContainerPort(long value) {
    this.containerPort = value;
  }

  public String getProtocol() {
    return protocol;
  }

  public void setProtocol(String value) {
    this.protocol = value;
  }
}
