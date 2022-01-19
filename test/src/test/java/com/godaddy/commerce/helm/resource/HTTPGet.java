package com.godaddy.commerce.helm.resource;

public class HTTPGet {

  private String path;
  private long port;
  private String scheme;
  private Env[] httpHeaders;

  public String getPath() {
    return path;
  }

  public void setPath(String value) {
    this.path = value;
  }

  public long getPort() {
    return port;
  }

  public void setPort(long value) {
    this.port = value;
  }

  public String getScheme() {
    return scheme;
  }

  public void setScheme(String value) {
    this.scheme = value;
  }

  public Env[] getHTTPHeaders() {
    return httpHeaders;
  }

  public void setHTTPHeaders(Env[] value) {
    this.httpHeaders = value;
  }
}
